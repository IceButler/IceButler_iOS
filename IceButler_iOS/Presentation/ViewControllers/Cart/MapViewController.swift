//
//  MapViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/13.
//

import UIKit

class MapViewController: UIViewController, MTMapViewDelegate {

    var mapView: MTMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupNavigationBar()
    }
    
    private func setupMapView() {
        mapView = MTMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.baseMapType = .standard
        self.view.addSubview(mapView)
    }
    
    private func setupNavigationBar() {
        /// setting status bar background color
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
            statusBar?.backgroundColor = UIColor.red
        }
        
        /// set up title
        let titleLabel = UILabel()
        titleLabel.text = "가까운 식료품점"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        /// set up right item
        let backItem = UIBarButtonItem(image: UIImage(named: "backIcon"), style: .done, target: self, action: #selector(didTapBackItem))
        backItem.tintColor = .white
        self.navigationItem.leftBarButtonItem = backItem
        
        self.navigationController?.navigationBar.backgroundColor = .navigationColor
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func didTapBackItem() {
        self.navigationController?.popViewController(animated: true)
    }
}
