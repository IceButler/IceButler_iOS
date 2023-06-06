//
//  UIDevice+.swift
//  IceButler_iOS
//
//  Created by 김초원 on 2023/03/30.
//

import Foundation
import UIKit

extension UIDevice {
    static var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
