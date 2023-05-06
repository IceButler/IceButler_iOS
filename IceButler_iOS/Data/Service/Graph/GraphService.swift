//
//  GraphService.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/05/06.
//

import Foundation
import Alamofire

class GraphService {
    func getWaste(fridgeIdx: Int, year: Int, month: Int, completion: @escaping ([FoodGraphList]) -> Void) {
        let parameters: Parameters = ["deleteCategory": "폐기",
                                     "year": year,
                                     "month": month]
        
        APIManger.shared.getData(urlEndpointString: "/fridges/\(fridgeIdx)/statistics", responseDataType: GraphResponseModel.self, parameter: parameters) { response in
            if let data = response.data {
                completion(data.foodStatisticsList)
            }
        }
    }
}
