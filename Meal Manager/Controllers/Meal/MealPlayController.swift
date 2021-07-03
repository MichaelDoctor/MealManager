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
    let lastAteLabel = UILabel()
    let dateLabel = UILabel()
    let dateStack = UIStackView()
    let eatenLabel = UILabel()
    let numEatenLabel = UILabel()
    let eatenStack = UIStackView()
    let retryButton = UIButton()
    let eatButton = UIButton()
    let buttonStack = UIStackView()
    
    var meal: Meal!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    
    private func configure() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        view.enableAutoLayout(bgImage, mealLabel, typeLabel, lastAteLabel, dateLabel, dateStack, eatenLabel, numEatenLabel, eatenStack, retryButton, eatButton, buttonStack)
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
    
    private func configureTitle(withPadding padding: CGFloat = 10) {
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
    
    private func configureType(withPadding padding: CGFloat = 10) {
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
//            typeLabel.bottomAnchor.constraint(equalTo: bgImage.bottomAnchor, constant: -padding)
        ])
    }
    
    private func configureDateStack(withPadding padding: CGFloat = 10) {
        dateStack.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            dateStack.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 50),
            dateStack.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: padding),
            dateStack.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: -padding),
            dateStack.heightAnchor.constraint(equalToConstant: 75)
//            dateStack.bottomAnchor.constraint(equalTo: bgImage.bottomAnchor, constant: -padding)
        ])
    }
    
    private func configureEatenStack(withPadding padding: CGFloat = 10) {
        eatenStack.backgroundColor = .green
        
        NSLayoutConstraint.activate([
            eatenStack.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: padding),
            eatenStack.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: padding),
            eatenStack.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: -padding),
            eatenStack.heightAnchor.constraint(equalToConstant: 75)
//            typeLabel.bottomAnchor.constraint(equalTo: bgImage.bottomAnchor, constant: -padding)
        ])
    }
    
    private func configureButtonStack(withPadding padding: CGFloat = 10) {
        buttonStack.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: eatenStack.bottomAnchor, constant: padding),
            buttonStack.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: padding),
            buttonStack.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: -padding),
            buttonStack.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}
