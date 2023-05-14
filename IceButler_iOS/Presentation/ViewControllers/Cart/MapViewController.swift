//
//  MapViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/13.
//

import UIKit

class MapViewController: UIViewController {

    private var mapView: MTMapView!
    private var storeData: [KakaoStoreData] = []
    
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet var infoView: UIView!
    @IBOutlet var infoInnerView: UIView!
    
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var storeAddressLabel: UILabel!
    @IBOutlet var storePhoneNumLabel: UILabel!
    
    
    
    @IBAction func didTapCurrentLocationButton(_ sender: UIButton) {
        // TODO: 현재 위치로 지도 이동
        print("TODO: 현재 위치로 지도 이동")
    }
    
    @IBAction func didTapViewStoreDetail(_ sender: UIButton) {
        // TODO: 카카오맵을 통해 가게 상세 정보 화면으로 이동
        print("TODO: 카카오맵을 통해 가게 상세 정보 화면으로 이동")
    }
    
    
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// TODO: 카카오 API를 사용한 카테고리별 장소 검색으로 가까운 식료품점 데이터 fetch
        ///      가져온 데이터를 기반으로 pin 구성
        ///      지도 중심을 현재 위치로 이동
        ///      핀 탭 이벤트를 통해 보여지는 info view의 더보기 버튼 탭 이벤트 정의 (카카오맵 상세 정보 화면으로 넘어가기)
        
        fetchKakaoData()
        setupView()
        setupMapView()
        setupNavigationBar()
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
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupView() {
        infoView.backgroundColor = .white
        infoView.layer.cornerRadius = 18
        
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.masksToBounds = false
        infoView.layer.shadowOffset = CGSize(width: 0, height: 0)
        infoView.layer.shadowRadius = 4
        infoView.layer.shadowOpacity = 0.2
        
        infoInnerView.layer.cornerRadius = 18
        
        currentLocationButton.layer.zPosition = 99
    }
    
    
    private func setupMapView() {
        mapView = MTMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.baseMapType = .standard
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMapView))
//        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        self.view.addSubview(mapView)
        
        setupPins()
        
    }
    
    private func setupPins() {
        let point1 = MTMapPOIItem()
        point1.tag = 1
        point1.itemName = nil
        point1.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.5309828, longitude: 126.8381839)) // 테스트용 위치
        point1.markerType = .redPin
//        point1.markerType = .customImage
//        point1.customImage = UIImage(named: "pin")
//        point1.customSelectedImage = UIImage(named: "pin.fill")
        
        mapView.addPOIItems([point1])
        
    }
    func loadViewAnimation() {
        UIView.transition(with: self.infoView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
            self.infoView.isHidden = !self.infoView.isHidden
            self.infoView.layer.zPosition = self.infoView.isHidden ? -100 : 100
        }, completion: nil);
    }
    
    // MARK: @objc methods
    @objc private func didTapBackItem() { self.navigationController?.popViewController(animated: true) }
    @objc private func didTapMapView() { loadViewAnimation() }
    
}

extension MapViewController: MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        // TODO: 마커 selectedImage로 변경
        storeNameLabel.text = storeData[poiItem.tag].place_name
        storeAddressLabel.text = storeData[poiItem.tag].road_address_name
        storePhoneNumLabel.text = storeData[poiItem.tag].phone
        loadViewAnimation()
        return false
    }
}


extension MapViewController {
    private func fetchKakaoData() {
        KakaoMapService.shared.getNearStoreData(x: 126.8381839,
                                                y: 37.5309828,
                                                completion: { [weak self] response in
            
            if response.documents.count > 0 {
                self?.storeData = response.documents
                self?.setupStorePins(storeData: response.documents)
            } else {
                let alert = UIAlertController(title: nil, message: "조회할 식료품점 정보가 없습니다!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }

        })
    }
    
    private func setupStorePins(storeData: [KakaoStoreData]) {
        var pins: [MTMapPOIItem] = []
        
        for i in 0..<storeData.count {
            let pin = MTMapPOIItem()
            pin.itemName = storeData[i].place_name
            pin.tag = i
            pin.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(storeData[i].y!) ?? 0,
                                                              longitude: Double(storeData[i].x!) ?? 0))
            pin.markerType = .customImage
            pin.customImage = UIImage(named: "pin")
            pins.append(pin)
        }
        mapView.addPOIItems(pins)
    }
}
