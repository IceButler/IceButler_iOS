//
//  GraphViewModel.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/05/06.
//

import Foundation
import Combine

class GraphViewModel: ObservableObject {
    static let shared = GraphViewModel()
    private let graphService = GraphService()
    
    @Published var wasteList: [FoodGraphList] = []
    @Published var consumeList: [FoodGraphList] = []
    
    private var cancelLabels: Set<AnyCancellable> = []
    
    
    func wasteList(completion: @escaping ([FoodGraphList]) -> Void) {
        $wasteList.filter { wasteList in
            wasteList.count > 0
        }.sink { wasteList in
            completion(wasteList)
        }.store(in: &cancelLabels)
    }
    
    func isChangeWasteList(completion: @escaping () -> Void) {
        $wasteList.filter { wasteList in
            wasteList.count > 0
        }.sink { wasteList in
            completion()
        }.store(in: &cancelLabels)
    }
    
    func consumeList(completion: @escaping ([FoodGraphList]) -> Void) {
        $consumeList.filter { consumeList in
            consumeList.count > 0
        }.sink { consumeList in
            completion(consumeList)
        }.store(in: &cancelLabels)
    }
    
    func isChangeConsumeList(completion: @escaping () -> Void) {
        $consumeList.filter { consumeList in
            consumeList.count > 0
        }.sink { consumeList in
            completion()
        }.store(in: &cancelLabels)
    }
    
}

extension GraphViewModel {
    func fetchWasteList(fridgeIdx: Int, year: Int, month: Int) {
        graphService.getWaste(fridgeIdx: fridgeIdx, year: year, month: month) { wasteList in
            self.wasteList = wasteList
        }
    }
    
    func fetchConsumeList(fridgeIdx: Int, year: Int, month: Int) {
        
    }
}
