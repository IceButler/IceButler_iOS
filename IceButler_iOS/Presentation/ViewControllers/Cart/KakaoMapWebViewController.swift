//
//  KakaoMapWebViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/15.
//

import UIKit
import WebKit

class KakaoMapWebViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    var webURL: String!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = .none
        self.tabBarController?.tabBar.isHidden = true
    
        guard let url = self.webURL else {return}
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
