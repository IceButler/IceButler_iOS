//
//  GraphMainViewController.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/05/06.
//

import UIKit
import Tabman
import Pageboy

class GraphMainViewController: TabmanViewController {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tabBarView: UIView!
    
    private var viewControllerList: [UIViewController] = []
    
    private var calendar = Calendar.current
    private var date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
        setupNavigation()
        setupTabman()
    }
    
    private func setup() {
        let componets = calendar.dateComponents([.month, .year], from: date)
        date = calendar.date(from: componets) ?? Date()
        
        setDateLabel()
    }
    
    private func setupNavigation() {
        self.tabBarController?.tabBar.isHidden = true
        
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.navigationColor
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.navigationColor
        }
        
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        
        let backItem = UIBarButtonItem(image: UIImage(named: "backIcon"), style: .done, target: self, action: #selector(backToScene))
        backItem.tintColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "카테고리별 통계"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationItem.titleView = titleLabel
    }
    
    @objc private func backToScene() {
        navigationController?.popViewController(animated: true)
    }
    
    
    private func setupTabman() {
        let wasteGraphVC = UIStoryboard(name: "WasteGraph", bundle: nil).instantiateViewController(identifier: "WasteGraphViewController") as! WasteGraphViewController
        let consumeGraphVC = UIStoryboard(name: "ConsumeGraph", bundle: nil).instantiateViewController(identifier: "ConsumeGraphViewController") as! ConsumeGraphViewController
       
        
        [wasteGraphVC, consumeGraphVC].forEach { vc in
            viewControllerList.append(vc)
        }
        
        self.dataSource = self
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        let bar = TMBar.ButtonBar()
        
        bar.backgroundView.style = .clear
        
        bar.buttons.customize { (button) in
            let tmpLabel = UILabel()
            tmpLabel.text = button.text
            tmpLabel.font = UIFont.systemFont(ofSize: 15)
            button.frame.size = CGSize(width: 163, height: 36)
            
            button.contentVerticalAlignment = .center
            button.font = UIFont.systemFont(ofSize: 15)
            button.tintColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
            button.selectedTintColor = .signatureBlue
        }
        
        bar.backgroundColor = .white
        
        bar.indicator.weight = .light
        bar.indicator.tintColor = .signatureBlue
        bar.indicator.overscrollBehavior = .bounce
        
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = 165
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 20.0)
        
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))
    }
    
    private func setDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy년 MM월"
        
        let dateString = dateFormatter.string(from: date)
        UIView.animate(withDuration: 0.5) {
            self.dateLabel.text = dateString
        }
    }
    
    
    
    @IBAction func minusDate(_ sender: Any) {
        date = calendar.date(byAdding: DateComponents(month: -1), to: date) ?? Date()
        let componets = calendar.dateComponents([.month, .year], from: date)
        setDateLabel()
        GraphViewModel.shared.fetchWasteList(fridgeIdx: 1, year: componets.year!, month: componets.month!)
        GraphViewModel.shared.fetchConsumeList(fridgeIdx: 1, year: componets.year!, month: componets.month!)
    }
    
    
    @IBAction func addDate(_ sender: Any) {
        date = calendar.date(byAdding: DateComponents(month: 1), to: date) ?? Date()
        let componets = calendar.dateComponents([.month, .year], from: date)
        setDateLabel()
        GraphViewModel.shared.fetchWasteList(fridgeIdx: 1, year: componets.year!, month: componets.month!)
        GraphViewModel.shared.fetchConsumeList(fridgeIdx: 1, year: componets.year!, month: componets.month!)
    }
    

}


extension GraphMainViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllerList.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllerList[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .at(index: 0)
    }
    
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        if index == 0 {
            return TMBarItem(title: "낭비")
        }else{
            return TMBarItem(title: "소비")
        }
    }
}

