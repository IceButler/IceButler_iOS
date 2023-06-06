//
//  KakaoMapService.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/15.
//

import Foundation
import Alamofire

class KakaoMapService {

    static let shared = KakaoMapService()

    private let KakaoURL = "https://dapi.kakao.com/v2/local/search/category.json?query="
    private let categoryCode = "&category_group_code=" + "MT1,CS2"  /// MT1 - 대형마트, CS2 - 편의점
    private let radius = "&radius=" + "2000"    /// 반경 2km 내로 검색 범위 제한
    private let page = "&page="
//    private let size = "&size=30"
//    private let sort = "&sort=distance" //거리순
    
    
    let headers: HTTPHeaders = [
        "Authorization": Config.Kakao_Map_Header,    /// rest api key
        "Accept": "application/json"
    ]
    
    func getNearStoreData(x: Double, y: Double, completion: @escaping ([KakaoStoreData]) -> Void) {

        var dataList: [KakaoStoreData] = []

        for i in 1...3 {
            let urlStr = KakaoURL + categoryCode + "&" + page + "\(i)" + radius + "&x=\(x)&y=\(y)"
            guard let target = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
            guard let url = URL(string: target) else { return }
            print("getNearStoreData called --> url : \(urlStr)")
            
            AF
                .request(url, method: .get, parameters: nil, headers: self.headers)
                .validate()
                .responseDecodable(of: KakaoMapDataModel.self) { response in
                    switch response.result {
                    case .success(let result):
                        print("카카오맵 데이터 조회 성공")
                        print(result.documents)
                        if i == 2 {
                            completion(dataList)
                        } else {
                            dataList.append(contentsOf: result.documents)
                        }
                    case .failure(let error):
                        print("카카오맵 데이터 조회 실패")
                        print(error.localizedDescription)
                        fatalError()
                    }
                }
                .resume()
        }
        
        
    }
}
