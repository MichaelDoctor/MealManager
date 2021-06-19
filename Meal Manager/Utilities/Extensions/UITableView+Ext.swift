//
//  UITableView+Ext.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-06-18.
//

import UIKit

extension UITableView {
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
