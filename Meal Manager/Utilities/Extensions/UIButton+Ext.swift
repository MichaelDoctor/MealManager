//
//  UIButton+Ext.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-06-15.
//

import UIKit

extension UIButton {
    func roundedButton(bg: UIColor, tint: UIColor) {
        backgroundColor = bg
        layer.cornerRadius = 12.0
        tintColor = tint
    }
}
