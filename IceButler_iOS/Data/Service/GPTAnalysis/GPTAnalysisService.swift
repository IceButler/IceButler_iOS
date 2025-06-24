//
//  GPTAnalysisService.swift
//  IceButler_iOS
//
//  Created by Claude on 2024/06/24.
//

import Foundation
import Combine

// MARK: - GPTAnalysisService
class GPTAnalysisService {
    static let shared = GPTAnalysisService()
    
    private let apiKey = "YOUR_OPENAI_API_KEY" // TODO: Config에서 가져오도록 수정
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    private init() {}
    
    enum GPTError: Error, LocalizedError {
        case invalidAPIKey
        case networkError
        case parsingError
        case rateLimitExceeded
        case unknown(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidAPIKey:
                return "OpenAI API 키가 올바르지 않습니다."
            case .networkError:
                return "네트워크 연결을 확인해주세요."
            case .parsingError:
                return "응답 데이터를 처리할 수 없습니다."
            case .rateLimitExceeded:
                return "API 사용량 한도를 초과했습니다."
            case .unknown(let message):
                return "알 수 없는 오류: \(message)"
            }
        }
    }
    
    // MARK: - Public Methods
    func analyzeFoodItems(from receiptText: String) -> AnyPublisher<[FoodItem], Error> {
        return Future<[FoodItem], Error> { promise in
            let prompt = self.createAnalysisPrompt(receiptText: receiptText)
            
            self.callOpenAI(with: prompt) { result in
                switch result {
                case .success(let response):
                    do {
                        let foodItems = try self.parseFoodItems(from: response)
                        promise(.success(foodItems))
                    } catch {
                        promise(.failure(GPTError.parsingError))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    private func createAnalysisPrompt(receiptText: String) -> String {
        return """
        다음 영수증 텍스트에서 식품 정보를 추출하고 분석해주세요.
        
        영수증 텍스트:
        \(receiptText)
        
        요구사항:
        1. 식품명만 추출 (세제, 생활용품 제외)
        2. 각 식품의 카테고리 분류 (Vegetable, Fruit, Meat, Fish, Dairy, Snack, Drink, Can, ETC)
        3. 적절한 보관 방법 추천 (refrigerator, freezer, pantry)
        4. 구매일 기준 예상 유통기한 계산 (오늘 날짜: \(DateFormatter.yyyyMMdd.string(from: Date())))
        
        JSON 형식으로 응답해주세요:
        [
          {
            "name": "식품명",
            "category": "카테고리",
            "storageType": "보관방법",
            "expiryDate": "YYYY-MM-DD"
          }
        ]
        
        식품이 없다면 빈 배열 []을 반환해주세요.
        """
    }
    
    private func callOpenAI(with prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard !apiKey.isEmpty && apiKey != "YOUR_OPENAI_API_KEY" else {
            completion(.failure(GPTError.invalidAPIKey))
            return
        }
        
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 1000,
            "temperature": 0.3
        ]
        
        guard let url = URL(string: baseURL),
              let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(GPTError.networkError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(GPTError.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(GPTError.networkError))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(.success(content))
                } else if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                          let error = json["error"] as? [String: Any],
                          let errorMessage = error["message"] as? String {
                    completion(.failure(GPTError.unknown(errorMessage)))
                } else {
                    completion(.failure(GPTError.parsingError))
                }
            } catch {
                completion(.failure(GPTError.parsingError))
            }
        }.resume()
    }
    
    private func parseFoodItems(from jsonString: String) throws -> [FoodItem] {
        // JSON 문자열에서 실제 JSON 부분만 추출
        let cleanedJSON = extractJSONFromResponse(jsonString)
        
        guard let data = cleanedJSON.data(using: .utf8) else {
            throw GPTError.parsingError
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        
        let gptItems = try decoder.decode([GPTFoodItem].self, from: data)
        
        return gptItems.compactMap { gptItem in
            guard let category = FoodCategory(rawValue: gptItem.category.lowercased()),
                  let storageType = StorageType(rawValue: gptItem.storageType.lowercased()) else {
                return nil
            }
            
            return FoodItem(
                name: gptItem.name,
                category: category,
                expiryDate: gptItem.expiryDate,
                storageType: storageType,
                isSelected: true
            )
        }
    }
    
    private func extractJSONFromResponse(_ response: String) -> String {
        // GPT 응답에서 JSON 부분만 추출
        let lines = response.components(separatedBy: .newlines)
        var jsonLines: [String] = []
        var insideJSON = false
        
        for line in lines {
            if line.trimmingCharacters(in: .whitespaces).hasPrefix("[") {
                insideJSON = true
            }
            
            if insideJSON {
                jsonLines.append(line)
            }
            
            if line.trimmingCharacters(in: .whitespaces).hasSuffix("]") && insideJSON {
                break
            }
        }
        
        return jsonLines.joined(separator: "\n")
    }
}

// MARK: - GPTFoodItem
private struct GPTFoodItem: Codable {
    let name: String
    let category: String
    let storageType: String
    let expiryDate: Date
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}