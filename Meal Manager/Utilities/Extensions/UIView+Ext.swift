//
//  UIView+Ext.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-06-14.
//

import UIKit
import ViewAnimator

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    
    func enableAutoLayout(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    
    func roundedView() {
        layer.cornerRadius = 12.0
        backgroundColor = UIColor.white.withAlphaComponent(0.75)
    }
    
    
    func popUpAnimation(_ views: UIView...) {
        let animation = AnimationType.zoom(scale: 0.3)
        for view in views {
            view.animate(animations: [animation])
        }
    }
}
