//
//  HorizontalLabelsStack.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-07-03.
//

import UIKit

class HorizontalLabelsStack: UIStackView {

    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
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
        rightLabel.text = rightText
    }
}

//MARK: - Configure Methods
extension HorizontalLabelsStack {
    private func configure() {
        leftLabel.font = UIFont(name: K.Fonts.openSans + K.Fonts.weight.bold, size: 20)
        leftLabel.textColor = UIColor(named: K.Color.black)
        leftLabel.textAlignment = .left
        leftLabel.shadowColor = .white
        leftLabel.shadowOffset = CGSize(width: -1, height: 1)
        leftLabel.minimumScaleFactor = 0.75
        
        rightLabel.font = UIFont(name: K.Fonts.openSans + K.Fonts.weight.bold, size: 20)
        rightLabel.textColor = UIColor(named: K.Color.black)
        rightLabel.textAlignment = .right
        rightLabel.shadowColor = .white
        rightLabel.shadowOffset = CGSize(width: -1, height: 1)
        rightLabel.minimumScaleFactor = 0.75
        
        spacing = 10
        axis = .horizontal
        distribution = .fillEqually
        addArrangedSubview(leftLabel)
        addArrangedSubview(rightLabel)
    }
}
