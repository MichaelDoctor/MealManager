//
//  MealPlayController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-06-04.
//

import UIKit
import CoreData

protocol  MealPlaycontrollerDelegate: AnyObject {
    var meals: [Meal] { get }
    var navigationController: UINavigationController? { get }
    func updateMeal(_ meal: Meal, newNum: Int)
}

class MealPlayController: UIViewController {
    
    let bgImage = UIImageView(image: UIImage(named: K.Images.generalScreen))
    let retryButton = UIButton()
    let eatButton = UIButton()
    let buttonStack = UIStackView()
    
    var mealLabel: HeaderLabel!
    var typeLabel: HeaderLabel!
    var dateStack: HorizontalLabelsStack!
    var eatenStack: HorizontalLabelsStack!
    var meal: Meal?
    var delegate: MealMainController!

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
        meal = delegate.meals.randomElement()
        self.updateUI()
        view.popUpAnimation(buttonStack, mealLabel, typeLabel, dateStack, eatenStack)
    }
    
    
    @objc func eatTapped() {
        guard let meal = meal else { return }
        
        delegate.updateMeal(meal, newNum: Int(meal.numberOfTimesEaten) + 1)
        
        #warning("Insert Detail View Controller later")
        
        dismiss(animated: true)
    }
}

//MARK: - Configure and Helper Functions
extension MealPlayController {
    private func configure() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        configureUIData()
        
        view.enableAutoLayout(bgImage, mealLabel, typeLabel, dateStack, eatenStack, retryButton, eatButton, buttonStack)
        view.addSubviews(bgImage, mealLabel, typeLabel, dateStack, eatenStack, buttonStack)
        
        configureBgImage()
        configureTitle()
        configureType()
        configureDateStack()
        configureEatenStack()
        configureButtonStack()
    }
    
    
    private func configureUIData() {
        if let meal = meal {
            mealLabel = HeaderLabel(labelText: meal.name ?? "Name Not Found", labelFont: UIFont(name: K.Fonts.montserrat + K.Fonts.weight.bold, size: 32)!, wordWrap: true, color: UIColor(named: K.Color.red)!)
            typeLabel = HeaderLabel(labelText: meal.type ?? "Type Not Found", labelFont: UIFont(name: K.Fonts.openSans + K.Fonts.weight.bold, size: 20)!)
            
            if let date = meal.lastAte {
                let dateFormatter = K.formatDate(date)
                dateStack = HorizontalLabelsStack(leftText: "Eaten On:", rightText: dateFormatter.string(from: date))
            } else {
                dateStack = HorizontalLabelsStack(leftText: "Eaten On:", rightText: "--")
            }
            
            eatenStack = HorizontalLabelsStack(leftText: "Times Eaten:", rightText: "\(meal.numberOfTimesEaten)")
        } else {
            mealLabel = HeaderLabel(labelText: "No Meals Found", labelFont: UIFont(name: K.Fonts.montserrat + K.Fonts.weight.bold, size: 32)!, wordWrap: true, color: UIColor(named: K.Color.red)!)
            typeLabel = HeaderLabel(labelText: "Add meals or change play filter settings.", labelFont: UIFont(name: K.Fonts.openSans + K.Fonts.weight.bold, size: 20)!, wordWrap: true)
            dateStack = HorizontalLabelsStack(leftText: "Eaten On:", rightText: "--")
            eatenStack = HorizontalLabelsStack(leftText: "Times Eaten:", rightText: "0")
            dateStack.isHidden = true
            eatenStack.isHidden = true
            buttonStack.isHidden = true
        }
    }
    
    
    private func updateUI() {
        guard let meal = meal else { return }
        
        DispatchQueue.main.async {
            self.mealLabel.text = meal.name ?? "Name Not Found"
            self.typeLabel.text = meal.type ?? "Type Not Found"
            
            if let date = meal.lastAte {
                let dateFormatter = K.formatDate(date)
                self.dateStack.rightLabel.text = dateFormatter.string(from: date)
            } else {
                self.dateStack.rightLabel.text = "--"
            }
            
            self.eatenStack.rightLabel.text = "\(meal.numberOfTimesEaten)"
        }
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
        NSLayoutConstraint.activate([
            mealLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            mealLabel.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: padding),
            mealLabel.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: -padding),
            mealLabel.heightAnchor.constraint(equalToConstant: 125),
        ])
    }
    
    
    private func configureType(withPadding padding: CGFloat = 10, multiplier: CGFloat = 4) {
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: mealLabel.bottomAnchor, constant: padding),
            typeLabel.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: padding*multiplier),
            typeLabel.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: -padding*multiplier),
            typeLabel.heightAnchor.constraint(equalToConstant: (meal != nil) ? 25 : 75)
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
