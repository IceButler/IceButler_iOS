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
    
    func waste(index: Int, store: inout Set<AnyCancellable>, completion: @escaping (FoodGraphList) -> Void) {
        $wasteList.filter { wasteList in
            wasteList.count > 0
        }.sink { wasteList in
            completion(wasteList[index])
        }.store(in: &cancelLabels)
    }
    
    func isChangeWasteList(completion: @escaping (Bool) -> Void) {
        $wasteList.sink { wasteList in
            if wasteList.count > 0 {
                completion(true)
            }else {
                completion(false)
            }
        }.store(in: &cancelLabels)
    }
    
    func consumeList(completion: @escaping ([FoodGraphList]) -> Void) {
        $consumeList.filter { consumeList in
            consumeList.count > 0
        }.sink { consumeList in
            completion(consumeList)
        }.store(in: &cancelLabels)
    }
    
    func isChangeConsumeList(completion: @escaping (Bool) -> Void) {
        $consumeList.sink { consumeList in
            if consumeList.count > 0 {
                completion(true)
            }else {
                completion(false)
            }
        }.store(in: &cancelLabels)
    }
    
    func consume(index: Int, store: inout Set<AnyCancellable>, completion: @escaping (FoodGraphList) -> Void) {
        $consumeList.filter { consumeList in
            consumeList.count > 0
        }.sink { consumeList in
            completion(consumeList[index])
        }.store(in: &cancelLabels)
    }
    
}

extension GraphViewModel {
    func fetchWasteList(year: Int, month: Int) {
        graphService.getWaste(year: year, month: month) { wasteList in
            wasteList.sorted {
                $0.percentage < $1.percentage
            }
            self.wasteList = wasteList
        }
    }
    
    func fetchConsumeList( year: Int, month: Int) {
        graphService.getConsume( year: year, month: month) { wasteList in
            wasteList.sorted {
                $0.percentage < $1.percentage
            }
            self.consumeList = wasteList
        }
    }
}
