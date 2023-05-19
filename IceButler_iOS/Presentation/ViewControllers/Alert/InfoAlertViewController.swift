//
//  InfoAlertViewController.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/05/13.
//

import UIKit

protocol FridgeRemoveDelegate {
    func reloadMyFridgeVC()
    func showMessageFailToRemoveFridge(message: String)
}

class InfoAlertViewController: UIViewController {
    
    var delegate: FridgeRemoveDelegate?
    
    private var isMulti: Bool = false
    private var isOwner: Bool = false
    private var removeFridgeIdx: Int = -1

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func didTapConfirmButton(_ sender: UIButton) { removeFridge() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 12
        confirmButton.layer.cornerRadius = 20
    }
    
    private func removeFridge() {
        var urlStr = ""
        
        if isMulti {
            if isOwner { urlStr = "/multiFridges/\(removeFridgeIdx)" }
            else { urlStr = "/multiFridges/\(removeFridgeIdx)/each" }
        } else {
            if isOwner { urlStr = "/fridges/\(removeFridgeIdx)/remove" }
            else { urlStr = "/fridges/\(removeFridgeIdx)/remove/each" }
        }
        
        if isMulti {
            // DELETE 요청
            APIManger.shared.deleteData(urlEndpointString: urlStr,
                                        responseDataType: Int.self,
                                        completionHandler: { [weak self] response in
                self?.dismiss(animated: true)
                switch response.statusCode {
                case 200:
                    self?.delegate?.reloadMyFridgeVC()
                default:
                    self?.delegate?.showMessageFailToRemoveFridge(message: response.description ?? "냉장고 삭제에 실패하였습니다")
                }
            })
        } else {
            // PATCH 요청
            APIManger.shared.patchData(urlEndpointString: urlStr,
                                       responseDataType: Int.self,
                                       completionHandler: { [weak self] response in
                self?.dismiss(animated: true)
                switch response.statusCode {
                case 200:
                    self?.delegate?.reloadMyFridgeVC()
                default:
                    self?.delegate?.showMessageFailToRemoveFridge(message: response.description ?? "냉장고 삭제에 실패하였습니다")
                }
            })
        }
        
    }
    
    public func setIsOwner(ownerIdx: Int) {
        APIManger.shared.getData(urlEndpointString: "/users",
                                 responseDataType: UserInfoResponseModel.self,
                                 parameter: nil,
                                 completionHandler: { [weak self] response in
            if let data = response.data {
                if data.userIdx == ownerIdx { self?.isOwner = true }
                else { self?.isOwner = false }
            }
        })
    }
    
    public func setRemoveInfo(isMulti: Bool, ownerIdx: Int, removeFridgeIdx: Int) {
        self.isMulti = isMulti
        self.removeFridgeIdx = removeFridgeIdx
        setIsOwner(ownerIdx: ownerIdx)
    }
}
