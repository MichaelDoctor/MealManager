//
//  HorizontalLabelButtonStack.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-07-04.
//

import UIKit

class HorizontalLabelButtonStack: UIStackView {

    let leftLabel = UILabel()
    let rightButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(leftText: String, rightText: String) {
        self.init(frame: .zero)
        leftLabel.text = leftText
        rightButton.setTitle(rightText, for: .normal)
    }
}

//MARK: - Configure Methods
extension HorizontalLabelButtonStack {
    private func configure() {
        leftLabel.font = UIFont(name: K.Fonts.openSans + K.Fonts.weight.bold, size: 20)
        leftLabel.textColor = UIColor(named: K.Color.black)
        leftLabel.textAlignment = .left
        leftLabel.shadowColor = .white
        leftLabel.shadowOffset = CGSize(width: -1, height: 1)
        leftLabel.minimumScaleFactor = 0.75
        
        rightButton.titleLabel?.font = UIFont(name: K.Fonts.openSans + K.Fonts.weight.bold, size: 20)
        rightButton.setTitleColor(UIColor(named: K.Color.accent), for: .normal)
        rightButton.setTitleColor(.gray, for: .highlighted)
        rightButton.contentHorizontalAlignment = .right
        rightButton.titleLabel?.lineBreakMode = .byTruncatingTail
        
        spacing = 10
        axis = .horizontal
        distribution = .fillEqually
        addArrangedSubview(leftLabel)
        addArrangedSubview(rightButton)
    }
}
