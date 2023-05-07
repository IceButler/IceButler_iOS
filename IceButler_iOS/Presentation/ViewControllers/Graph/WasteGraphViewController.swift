//
//  WasteGraphViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/05/06.
//

import UIKit
import Charts

class WasteGraphViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var wasteCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupObserver()
    }
    
    private func setup() {
        GraphViewModel.shared.fetchWasteList(fridgeIdx: 1, year: 2023, month: 4)
    }
    
    private func setupObserver() {
        GraphViewModel.shared.wasteList { wasteList in
            self.setupPieChart(wasteList: wasteList)
        }
    }
    
    private func setupPieChart(wasteList: [FoodGraphList]) {
        var pieDataEntryList: [ChartDataEntry] = []
        var pieDataColorList: [UIColor] = []
        
        
        
        for i in 0..<wasteList.count {
            let pieDataEntry = ChartDataEntry(x: Double(i), y: Double(wasteList[i].percentage))
            pieDataEntryList.append(pieDataEntry)
            
            FoodCategory.AllCases().forEach { category in
                if wasteList[i].foodCategory == category.rawValue {
                    pieDataColorList.append(category.color)
                }
            }
        }
        
        let pieChartDataSet = PieChartDataSet(entries: pieDataEntryList)
        pieChartDataSet.colors = pieDataColorList
        pieChartDataSet.highlightEnabled = false
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
    }
    
    


}
