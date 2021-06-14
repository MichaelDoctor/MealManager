//
//  UIViewContoller+Ext.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-06-14.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
