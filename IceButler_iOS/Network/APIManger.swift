//
//  APIManger.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/03.
//

import Foundation
import Alamofire

private let BASE_URL = "https://za8hqdiis4.execute-api.ap-northeast-2.amazonaws.com/dev/dev-ice-bulter-main"
private let RECIPE_URL = "https://za8hqdiis4.execute-api.ap-northeast-2.amazonaws.com/dev/dev-ice-bulter-recipe"

class APIManger {
    static let shared = APIManger()
    
    private var headers: HTTPHeaders?
    
    private var fridgeIdx: Int = -1
    private var isMultiFridge: Bool = false
    
    func setupObserver() {
        AuthViewModel.shared.accessToken { token in
            self.headers = ["Authorization": token]
        }
    }
    
    func getFridgeUrl() -> String {
        if isMultiFridge {
            return "/multiFridges"
        }else {
            return "/fridges"
        }
    }
}

// MARK: 냉장고 Index 및 공용/가정용 구분값의 get/set
extension APIManger {
    func setFridgeIdx(index: Int) { fridgeIdx = index }
    func getFridgeIdx() -> Int { return fridgeIdx }
    
    func setIsMultiFridge(isMulti: Bool) { isMultiFridge = isMulti }
    func getIsMultiFridge() -> Bool { return isMultiFridge }
}

extension APIManger {
    func getData<T: Codable, U: Decodable>(urlEndpointString: String,
                                           responseDataType: U.Type,
                                           requestDataType: T.Type,
                                           parameter: T?,
                                           completionHandler: @escaping (GeneralResponseModel<U>)->Void) {
        
        guard let url = URL(string: BASE_URL + urlEndpointString) else { return }
        
        AF
            .request(url, method: .get, parameters: parameter, headers: self.headers)
            .responseDecodable(of: GeneralResponseModel<U>.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    
    func getData<U: Decodable>(urlEndpointString: String,
                               responseDataType: U.Type,
                               parameter: Parameters?,
                               completionHandler: @escaping (GeneralResponseModel<U>)->Void) {
        
        guard let url = URL(string: BASE_URL + urlEndpointString) else { return }
        
        AF
            .request(url, method: .get, parameters: parameter, encoding: URLEncoding.queryString, headers: self.headers)
            .responseDecodable(of: GeneralResponseModel<U>.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    func getRecipeData<U: Decodable>(urlEndpointString: String,
                               responseDataType: U.Type,
                               parameter: Parameters?,
                               completionHandler: @escaping (GeneralResponseModel<U>)->Void) {

        guard let url = URL(string: RECIPE_URL + urlEndpointString) else { return }

        AF
            .request(url, method: .get, parameters: parameter, encoding: URLEncoding.queryString, headers: self.headers)
            .responseDecodable(of: GeneralResponseModel<U>.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
          
    func getListData<U: Decodable>(urlEndpointString: String,
                               responseDataType: U.Type,
                               parameter: Parameters?,
                               completionHandler: @escaping (GeneralResponseListModel<U>)->Void) {
        
        guard let url = URL(string: BASE_URL + urlEndpointString) else { return }
        
        AF
            .request(url, method: .get, parameters: parameter, encoding: URLEncoding.queryString, headers: self.headers)
            .responseDecodable(of: GeneralResponseListModel<U>.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    func postData<T: Codable, U: Decodable>(urlEndpointString: String,
                                            responseDataType: U.Type,
                                            requestDataType: T.Type,
                                            parameter: T?,
                                            completionHandler: @escaping (GeneralResponseModel<U>)->Void) {
        
        guard let url = URL(string: BASE_URL + urlEndpointString) else { return }
        
        AF
            .request(url, method: .post, parameters: parameter, encoder: .json, headers: self.headers)
            .responseDecodable(of: GeneralResponseModel<U>.self) { response in

                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    func postRecipeData<T: Codable, U: Decodable>(urlEndpointString: String,
                                                  responseDataType: U.Type,
                                                  requestDataType: T.Type,
                                                  parameter: T?,
                                                  completionHandler: @escaping (GeneralResponseModel<U>)->Void) {
        guard let url = URL(string: RECIPE_URL + urlEndpointString) else { return }
        
        AF
            .request(url, method: .post, parameters: parameter, encoder: .json, headers: self.headers)
            .responseDecodable(of: GeneralResponseModel<U>.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    func postRecipeData<U: Decodable>(urlEndpointString: String,
                                      responseDataType: U.Type,
                                      completionHandler: @escaping (GeneralResponseModel<U>)->Void) {
        guard let url = URL(string: RECIPE_URL + urlEndpointString) else { return }
        
        AF
            .request(url, method: .post, headers: self.headers)
            .responseDecodable(of: GeneralResponseModel<U>.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    func getData<T: Codable, U: Decodable>(url: String,
                                           responseDataType: U.Type,
                                           requestDataType: T.Type,
                                           parameter: T?,
                                           completionHandler: @escaping (GeneralResponseModel<U>)->Void) {
        
        guard let url = URL(string: url) else { return }
        
        AF
            .request(url, method: .get, parameters: parameter, headers: headers)
            .responseDecodable(of: GeneralResponseModel<U>.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    
    func getImageUrl(url: String, parameter: Parameters?, completionHandler: @escaping (ImageResponseModel?)->Void) {
        guard let url = URL(string: url) else { return }
        AF
            .request(url, method: .get, parameters: parameter, headers: nil)
            .responseDecodable(of: ImageResponseModel.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }.resume()
    }
    
    func getImageUrl(url: String, parameter: Parameters?) async throws -> ImageResponseModel? {
        guard let url = URL(string: url) else { return nil }
        return try await AF
            .request(url, method: .get, parameters: parameter, headers: nil)
            .serializingDecodable(ImageResponseModel.self)
            .value
    }
    
    func getGpt<T: Codable>(url: String, responseDataType: T.Type,  parameter: Parameters?, completionHandler: @escaping (T?)->Void) {
        guard let url = URL(string: url) else {return}
        
        AF
            .request(url, method: .get, parameters: parameter, headers: nil)
            .responseDecodable(of: T.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }.resume()
    }
    
    
    func putData<T: Codable, U: Decodable>(urlEndpointString: String,
                                            responseDataType: U.Type,
                                            requestDataType: T.Type,
                                            parameter: T?,
                                            completionHandler: @escaping (GeneralResponseModel<U>)->Void) {
        
        guard let url = URL(string: BASE_URL + urlEndpointString) else { return }
        
        AF
            .request(url, method: .put, parameters: parameter, encoder: .json, headers: nil)
            .responseDecodable(of: GeneralResponseModel<U>.self) { response in
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    
    func putData(url: String, data: Data, completion: @escaping () -> Void) {
        let url = URL(string: url)

        AF.upload(data, to: url!, method: .put).responseData(emptyResponseCodes: [200]) { response in
            print(response)
            switch response.result {
            case .success(let _):
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func deleteData<T: Codable, U: Decodable>(urlEndpointString: String,
                                            responseDataType: U.Type,
                                            requestDataType: T.Type,
                                            parameter: T?,
                                            completionHandler: @escaping (GeneralResponseModel<U>)->Void) {
        
        guard let url = URL(string: BASE_URL + urlEndpointString) else { return }
        
        AF
            .request(url, method: .delete, parameters: parameter, encoder: .json, headers: self.headers)
            .responseDecodable(of: GeneralResponseModel<U>.self) { response in

                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    func deleteData<U: Decodable>(urlEndpointString: String,
                                            responseDataType: U.Type,
                                            completionHandler: @escaping (GeneralResponseModel<U>)->Void) {
        
        guard let url = URL(string: BASE_URL + urlEndpointString) else { return }
        print("삭제 요청 URL --> \(url)")
        AF
            .request(url, method: .delete, headers: self.headers)
            .responseDecodable(of: GeneralResponseModel<U>.self) { response in

                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    func patchData<T: Codable, U: Decodable>(urlEndpointString: String,
                                            responseDataType: U.Type,
                                            requestDataType: T.Type,
                                            parameter: T?,
                                            completionHandler: @escaping (GeneralResponseModel<U>)->Void) {
        
        guard let url = URL(string: BASE_URL + urlEndpointString) else { return }
        print("삭제 요청 URL --> \(url)")
        AF
            .request(url, method: .patch, parameters: parameter, encoder: .json, headers: self.headers)
            .responseDecodable(of: GeneralResponseModel<U>.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    func patchData<U: Decodable>(urlEndpointString: String,
                                 responseDataType: U.Type,
                                 completionHandler: @escaping (GeneralResponseModel<U>)->Void) {
        
        guard let url = URL(string: BASE_URL + urlEndpointString) else { return }
        
        AF
            .request(url, method: .patch, headers: self.headers)
            .responseDecodable(of: GeneralResponseModel<U>.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
}

