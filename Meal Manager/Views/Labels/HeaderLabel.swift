//
//  HeaderLabel.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-07-03.
//

import UIKit

class HeaderLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(labelText: String, labelFont: UIFont, wordWrap: Bool = false, color: UIColor = UIColor(named: K.Color.black)!) {
        self.init(frame: .zero)
        text = labelText
        font = labelFont
        textColor = color
        if wordWrap {
            numberOfLines = 0
            lineBreakMode = .byWordWrapping
        }
    }
}

extension HeaderLabel {
    private func configure() {
        textAlignment = .center
        shadowColor = .white
        shadowOffset = CGSize(width: -1, height: 1)
    }
}
