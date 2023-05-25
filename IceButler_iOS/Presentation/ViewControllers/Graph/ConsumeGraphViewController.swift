//
//  ConsumeGraphViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/05/06.
//

import UIKit
import Charts

class ConsumeGraphViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var consumeCollectionView: UICollectionView!
    
    private var isEntryEmpty = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupLayout()
        setupObserver()
    }
    
    private func setup() {
        pieChartView.noDataText = "해당 달에 통계가 없습니다."
        pieChartView.noDataFont = UIFont.systemFont(ofSize: 20)
        
        consumeCollectionView.delegate = self
        consumeCollectionView.dataSource = self
        
        let cell = UINib(nibName: "FoodRemoveRankCell", bundle: nil)
        consumeCollectionView.register(cell, forCellWithReuseIdentifier: "FoodRemoveRankCell")
    }
    
    private func setupLayout() {
        pieChartView.layer.shadowColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.03)
        pieChartView.layer.shadowOffset = CGSize(width: 0, height: 4)
        pieChartView.layer.shadowRadius = 30
        pieChartView.layer.shadowOpacity = 1
    }
    
    private func setupObserver() {
        GraphViewModel.shared.consumeList { consumeList in
            self.setupPieChart(consumeList: consumeList)
        }
    }
    
    private func setupPieChart(consumeList: [FoodGraphList]) {
        var pieDataEntryList: [PieChartDataEntry] = []
        var pieDataColorList: [UIColor] = []
        
        
        
        for i in 0..<consumeList.count {
            if consumeList[i].percentage == 0 {
                continue
            }
            let pieDataEntry = PieChartDataEntry(value: consumeList[i].percentage, label: consumeList[i].foodCategory)
            pieDataEntryList.append(pieDataEntry)
            pieDataColorList.append(getColor(rawValue: consumeList[i].foodCategory))
        }
        
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.highlightPerTapEnabled = false
        pieChartView.rotationEnabled = false
        pieChartView.rotationWithTwoFingers = false
        pieChartView.legend.orientation = .vertical
        pieChartView.legend.horizontalAlignment = .right
        pieChartView.legend.verticalAlignment = .center
        pieChartView.legend.yEntrySpace = 3
        
        pieChartView.legend.font = UIFont.systemFont(ofSize: 12)
        
        if pieDataEntryList.count == 0 {
            pieChartView.data = nil
            isEntryEmpty = true
        }else {
            let pieChartDataSet = PieChartDataSet(entries: pieDataEntryList, label: "")
            pieChartDataSet.drawValuesEnabled = false
            pieChartDataSet.colors = pieDataColorList
            pieChartDataSet.highlightEnabled = false
            
            let pieChartData = PieChartData(dataSet: pieChartDataSet)
            pieChartView.data = pieChartData
            isEntryEmpty = false
        }
        pieChartView.animate(yAxisDuration: 2.0)
        reloadCollectionView()
    }
    
    private func getColor(rawValue: String) -> UIColor {
        switch rawValue {
        case FoodCategory.Meat.rawValue:
            return UIColor(red: 0.976, green: 0.776, blue: 0.847, alpha: 1)
        case FoodCategory.Fruit.rawValue:
            return UIColor(red: 0.988, green: 0.78, blue: 0.667, alpha: 1)
        case FoodCategory.Vegetable.rawValue:
            return UIColor(red: 0.769, green: 0.91, blue: 0.663, alpha: 1)
        case FoodCategory.Drink.rawValue:
            return UIColor(red: 1, green: 0.915, blue: 0.613, alpha: 1)
        case FoodCategory.MarineProducts.rawValue:
            return UIColor(red: 0.655, green: 0.763, blue: 0.908, alpha: 1)
        case FoodCategory.Side.rawValue:
            return UIColor(red: 1, green: 0.721, blue: 0.683, alpha: 1)
        case FoodCategory.Snack.rawValue:
            return UIColor(red: 0.9, green: 0.817, blue: 0.921, alpha: 1)
        case FoodCategory.Seasoning.rawValue:
            return UIColor(red: 0.713, green: 0.817, blue: 0.892, alpha: 1)
        case FoodCategory.ProcessedFood.rawValue:
            return UIColor(red: 0.808, green: 0.816, blue: 0.949, alpha: 1)
        case FoodCategory.ETC.rawValue:
            return UIColor(red: 0.799, green: 0.908, blue: 0.869, alpha: 1)
        default:
            return UIColor.black
        }
    }
    
    private func reloadCollectionView() {
        UIView.transition(with: self.consumeCollectionView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
            self.consumeCollectionView.reloadData()},
                          completion: nil)
    }
}

extension ConsumeGraphViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isEntryEmpty {
            return 0
        }else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodRemoveRankCell", for: indexPath) as! FoodRemoveRankCell
        
        GraphViewModel.shared.consume(index: indexPath.row, store: &cell.cancelLabels) { data in
            cell.configure(data: data, color: self.getColor(rawValue: data.foodCategory), kind: .consume)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 358, height: 92)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 30, right: 0)
    }
}
