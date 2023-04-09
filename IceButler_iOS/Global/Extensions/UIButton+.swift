//
//  UIButton+.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/04/07.
//

import Foundation
import UIKit

extension UIButton {
    func alignTextLeft() {
        contentHorizontalAlignment = .left
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
    }
}
