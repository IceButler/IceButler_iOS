//
//  MapViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/13.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController {

    private var locationManager : CLLocationManager!
    private var currentLa: Double = 0.0
    private var currentLo: Double = 0.0
    private var selectedPinTag: Int = -1
    
    private var isPinSelected: Bool = false
    
    private var mapView: MTMapView!
    private var storeData: [KakaoStoreData] = []
    private var currentStoreWebUrl = ""     /// 가게 상세 정보 탭할 경우 웹뷰로 넘어가기 위한 url
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet var infoView: UIView!
    @IBOutlet var infoInnerView: UIView!
    
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var storeAddressLabel: UILabel!
    @IBOutlet var storePhoneNumLabel: UILabel!
    
    @IBOutlet var navigationButton: UIButton!
    
    
    private var url: URL?
    
    
    @IBAction func didTapCurrentLocationButton(_ sender: UIButton) {
        mapView.setMapCenter(.init(geoCoord: .init(latitude: currentLa, longitude: currentLo)), animated: true)
    }
    
    @IBAction func didTapViewStoreDetail(_ sender: UIButton) {
        if currentStoreWebUrl.count > 0 {
            let webView = KakaoMapWebViewController()
            webView.webURL = currentStoreWebUrl
            self.navigationController?.pushViewController(webView, animated: true)
            
        } else {
            let alert = UIAlertController(title: nil, message: "가게 상세정보 조회를 위한 URL이 없습니다!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocation()
        setupView()
        setupMapView()
        fetchKakaoData()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLocation()
        setupView()
        setupMapView()
        fetchKakaoData()
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupLayout() {
        navigationButton.layer.cornerRadius = 10
        navigationButton.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        navigationButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationButton.layer.shadowOpacity = 2
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
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupView() {
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeDownGesture.direction = .down
        self.infoView.addGestureRecognizer(swipeDownGesture)
        
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
    
    private func setupLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupMapView() {
        mapView = MTMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.baseMapType = .standard
        
        self.containerView.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        
        setupCurrentLocationPin()
    }
    
    private func setupCurrentLocationPin() {
        let longitude = locationManager.location?.coordinate.longitude
        let latitude = locationManager.location?.coordinate.latitude
        
        if let _ = latitude,
           let _ = longitude {
            
            self.currentLa = latitude!
            self.currentLo = longitude!
            
            let currentPoint = MTMapPOIItem()
            currentPoint.tag = 1
            currentPoint.itemName = nil
            currentPoint.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: currentLa, longitude: longitude!))
            currentPoint.markerType = .redPin
            mapView.addPOIItems([currentPoint])
            
            mapView.setMapCenter(.init(geoCoord: .init(latitude: currentLa, longitude: currentLo)), animated: true)
            
        } else {
            let alert = UIAlertController(title: "식료품점 조회 실패", message: "위치 정보 수집 권한이 설정되어 있지 않습니다!", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    func loadViewAnimation(tag: Int) {
        if selectedPinTag == tag {
            self.currentLocationButton.isHidden = false
            self.infoView.isHidden = true
        } else {
            UIView.transition(with: self.infoView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { () -> Void in
                self.currentLocationButton.isHidden = true
                self.infoView.isHidden = false
            }, completion: nil);
        }
    }
    
    // MARK: @objc methods
    @objc private func didTapBackItem() { self.navigationController?.popViewController(animated: true) }
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .down {
            UIView.transition(with: self.infoView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { () -> Void in
                self.infoView.isHidden = true
                self.currentLocationButton.isHidden = false
            }, completion: nil);

        }
    }
    
    
    @IBAction func moveToNavigation(_ sender: Any) {
        
        let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!

        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
        }else {
            UIApplication.shared.open(appStoreURL)
        }
    }
    
}

// MARK: Delegate Extensions
extension MapViewController: MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        
        loadViewAnimation(tag: poiItem.tag)
        
        selectedPinTag = poiItem.tag
        currentStoreWebUrl = storeData[poiItem.tag].place_url ?? ""
        
        storeNameLabel.text = storeData[poiItem.tag].place_name
        storeAddressLabel.text = storeData[poiItem.tag].road_address_name
        storePhoneNumLabel.text = (storeData[poiItem.tag].phone!.count > 0) ? storeData[poiItem.tag].phone : "전화번호가 없습니다."
        
        guard let dlat = storeData[poiItem.tag].y else {return false}
        guard let dlng = storeData[poiItem.tag].x else {return false}
        guard let placeName = storeData[poiItem.tag].place_name else {return false}
        
        let urlStr = "nmap://route/walk?dlat=\(dlat)&dlng=\(dlng)&dname=\(placeName)&appname=yoosang.IceButler-iOS"
        let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        url = URL(string: encodedStr)!
        
        return false
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .notDetermined:
            print("GPS 권한 설정되지 않음")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("GPS 권한 거부됨")
            locationManager.requestWhenInUseAuthorization()
        default: return
        }
    }
}


// MARK: 카카오맵 API 사용 관련 메소드
extension MapViewController {
    private func fetchKakaoData() {
        let longitude = locationManager.location?.coordinate.longitude
        let latitude = locationManager.location?.coordinate.latitude
        KakaoMapService.shared.getNearStoreData(x: self.currentLo,
                                                y: self.currentLa,
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
            pin.markerSelectedType = .customImage
            pin.customImage = UIImage(named: "pin")
            pin.customSelectedImage = UIImage(named: "pin.fill")
            pins.append(pin)
        }
        mapView.addPOIItems(pins)
    }
}
