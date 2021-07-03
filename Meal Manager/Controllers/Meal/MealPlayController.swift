//
//  MealPlayController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-06-04.
//

import UIKit

class MealPlayController: UIViewController {
    
    let bgImage = UIImageView(image: UIImage(named: K.Images.generalScreen))
    let mealLabel = UILabel()
    let typeLabel = UILabel()
    let dateStack = HorizontalLabelsStack(leftText: "Eaten On:", rightText: "--")
    let eatenStack = HorizontalLabelsStack(leftText: "Times Eaten:", rightText: "0")
    let retryButton = UIButton()
    let eatButton = UIButton()
    let buttonStack = UIStackView()
    
    var meal: Meal!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
}

//MARK: - Buttons
extension MealPlayController {
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    
    
    @objc func retryTapped() {
        print("retry tapped")
    }
    
    
    @objc func eatTapped() {
        print("Eat tapped")
    }
}

//MARK: - Configure Functions
extension MealPlayController {
    private func configure() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        view.enableAutoLayout(bgImage, mealLabel, typeLabel, dateStack, eatenStack, retryButton, eatButton, buttonStack)
        view.addSubviews(bgImage, mealLabel, typeLabel, dateStack, eatenStack, buttonStack)
        
        configureBgImage()
        configureTitle()
        configureType()
        configureDateStack()
        configureEatenStack()
        configureButtonStack()
    }
    
    private func configureBgImage() {
        bgImage.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: view.topAnchor),
            bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureTitle(withPadding padding: CGFloat = 10, multiplier: CGFloat = 4) {
        mealLabel.text = "Wow Chicken"
        mealLabel.font = UIFont(name: K.Fonts.montserrat + K.Fonts.weight.bold, size: 32)
        mealLabel.textColor = UIColor(named: K.Color.black)
        mealLabel.textAlignment = .center
        mealLabel.shadowColor = .white
        mealLabel.shadowOffset = CGSize(width: -1, height: 1)
        mealLabel.numberOfLines = 0
        mealLabel.lineBreakMode = .byWordWrapping
        
        NSLayoutConstraint.activate([
            mealLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            mealLabel.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: padding),
            mealLabel.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: -padding),
            mealLabel.heightAnchor.constraint(equalToConstant: 125),
        ])
    }
    
    private func configureType(withPadding padding: CGFloat = 10, multiplier: CGFloat = 4) {
        typeLabel.text = "Ordered"
        typeLabel.font = UIFont(name: K.Fonts.openSans + K.Fonts.weight.bold, size: 20)
        typeLabel.textColor = UIColor(named: K.Color.black)
        typeLabel.textAlignment = .center
        typeLabel.shadowColor = .white
        typeLabel.shadowOffset = CGSize(width: -1, height: 1)
        typeLabel.minimumScaleFactor = 0.75
        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: mealLabel.bottomAnchor, constant: padding),
            typeLabel.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: padding),
            typeLabel.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: -padding),
            typeLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureDateStack(withPadding padding: CGFloat = 10, multiplier: CGFloat = 4) {
        NSLayoutConstraint.activate([
            dateStack.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 50),
            dateStack.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: padding*multiplier),
            dateStack.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: -padding*multiplier),
            dateStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureEatenStack(withPadding padding: CGFloat = 10, multiplier: CGFloat = 4) {
        NSLayoutConstraint.activate([
            eatenStack.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: padding),
            eatenStack.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: padding*multiplier),
            eatenStack.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: -padding*multiplier),
            eatenStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureButtonStack(withPadding padding: CGFloat = 10, multiplier: CGFloat = 4) {
        retryButton.setImage(UIImage(systemName: K.Images.retryImage), for: .normal)
        retryButton.roundedButton(bg: .white, tint: UIColor(named: K.Color.accent)!)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        
        eatButton.setTitle("Eat", for: .normal)
        eatButton.titleLabel?.font = UIFont(name: K.Fonts.openSans+K.Fonts.weight.bold, size: 20)
        eatButton.setTitleColor(.gray, for: .highlighted)
        eatButton.roundedButton(bg: UIColor(named: K.Color.accent)!, tint: .white)
        eatButton.addTarget(self, action: #selector(eatTapped), for: .touchUpInside)
        
        
        buttonStack.spacing = 10
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.addArrangedSubview(retryButton)
        buttonStack.addArrangedSubview(eatButton)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: eatenStack.bottomAnchor, constant: padding),
            buttonStack.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: padding*multiplier),
            buttonStack.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: -padding*multiplier),
            buttonStack.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
