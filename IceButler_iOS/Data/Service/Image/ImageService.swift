//
//  ImageService.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/13.
//

import Foundation
import UIKit
import Alamofire

class ImageService {
    static let shared = ImageService()
    
    func getImageUrl(parameter: Parameters, completion: @escaping (ImageResponseModel?) -> Void) {
        APIManger.shared.getImageUrl(url: "https://za8hqdiis4.execute-api.ap-northeast-2.amazonaws.com/prod/presigned-url", parameter: parameter) { response in
            completion(response)
        }
    }
    
    func uploadImage(image: UIImage, url: String, compeltion: @escaping () -> Void) {
        guard let imageToData = image.jpegData(compressionQuality: 1) else { return }
        APIManger.shared.putData(url: url, data: imageToData, completion: compeltion)
    }
    
    func getRecipeImageUrl(parameter: Parameters) async throws -> ImageResponseModel? {
        let response = try? await APIManger.shared.getImageUrl(url: "https://za8hqdiis4.execute-api.ap-northeast-2.amazonaws.com/prod/presigned-url", parameter: parameter)
        return response
    }

    func uploadRecipeImage(image: UIImage, url: String, compeltion: @escaping () -> Void) {
        guard let imageToData = image.jpegData(compressionQuality: 1) else { return }
        APIManger.shared.putData(url: url, data: imageToData, completion: compeltion)
    }
}
