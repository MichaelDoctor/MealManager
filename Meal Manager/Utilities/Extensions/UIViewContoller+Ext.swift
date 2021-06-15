//
//  UIViewContoller+Ext.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-06-14.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentSafariVC(with url: URL, title: String) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = UIColor(named: K.Color.accent)
        let navController = UINavigationController(rootViewController: safariVC)
        navController.navigationBar.isHidden = true
        present(navController, animated: true)
    }
}
