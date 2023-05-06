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
            self.pieChartView.setValues(values: wasteList)
        }
    }

}
