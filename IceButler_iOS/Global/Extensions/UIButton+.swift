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
        contentHorizontalAlignment = .leading
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
}
