//
//  ReceiptOCRService.swift
//  IceButler_iOS
//
//  Created by Claude on 2024/06/24.
//

import Foundation
import Vision
import UIKit
import RxSwift

// MARK: - ReceiptOCRService
class ReceiptOCRService {
    static let shared = ReceiptOCRService()
    
    private init() {}
    
    enum OCRError: Error, LocalizedError {
        case invalidImage
        case noTextDetected
        case processingFailed
        
        var errorDescription: String? {
            switch self {
            case .invalidImage:
                return "올바르지 않은 이미지입니다."
            case .noTextDetected:
                return "텍스트를 인식할 수 없습니다."
            case .processingFailed:
                return "이미지 처리에 실패했습니다."
            }
        }
    }
    
    // MARK: - Public Methods
    func extractText(from image: UIImage) -> Observable<String> {
        return Observable.create { observer in
            guard let cgImage = image.cgImage else {
                observer.onError(OCRError.invalidImage)
                return Disposables.create()
            }
            
            let request = VNRecognizeTextRequest { (request, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    observer.onError(OCRError.noTextDetected)
                    return
                }
                
                let recognizedStrings = observations.compactMap { observation in
                    return observation.topCandidates(1).first?.string
                }
                
                let fullText = recognizedStrings.joined(separator: "\n")
                
                if fullText.isEmpty {
                    observer.onError(OCRError.noTextDetected)
                } else {
                    observer.onNext(fullText)
                    observer.onCompleted()
                }
            }
            
            // OCR 설정
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["ko-KR", "en-US"]
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    observer.onError(OCRError.processingFailed)
                }
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - Preprocessing
    private func preprocessImage(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let context = CIContext()
        let ciImage = CIImage(cgImage: cgImage)
        
        // 대비 향상
        let contrastFilter = CIFilter(name: "CIColorControls")
        contrastFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        contrastFilter?.setValue(1.2, forKey: kCIInputContrastKey)
        
        guard let contrastOutput = contrastFilter?.outputImage else { return image }
        
        // 밝기 조정
        let brightnessFilter = CIFilter(name: "CIColorControls")
        brightnessFilter?.setValue(contrastOutput, forKey: kCIInputImageKey)
        brightnessFilter?.setValue(0.1, forKey: kCIInputBrightnessKey)
        
        guard let brightnessOutput = brightnessFilter?.outputImage,
              let outputCGImage = context.createCGImage(brightnessOutput, from: brightnessOutput.extent) else {
            return image
        }
        
        return UIImage(cgImage: outputCGImage)
    }
}