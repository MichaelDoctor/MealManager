//
//  MealDetailViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-06-04.
//

import UIKit
import GoogleMobileAds

class MealDetailViewController: UIViewController {
    
    private let banner: GADBannerView = GoogleAdMobManager.sharedForDetail
    let bgImage = UIImageView(image: UIImage(named: K.Images.generalScreen))
    
    var mealLabel: HeaderLabel!
    var typeLabel: HeaderLabel!
    var dateStack: HorizontalLabelsStack!
    var eatenStack: HorizontalLabelsStack!
    var meal: Meal!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        GoogleAdMobManager.layoutAd(forView: view, tabBarController: tabBarController)
    }
}

//MARK: - Buttons
extension MealDetailViewController {
    @objc func deleteTapped() {
        print("Delete")
    }
    
    
    @objc func editTapped() {
        print("Edit")
    }
}

//MARK: - Core Data
extension MealDetailViewController {
    func loadData() {
        
    }
}

//MARK: - Configure Functions
extension MealDetailViewController {
    private func configure() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped)),
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTapped))
        ]
        configureUIData()
        banner.rootViewController = self
        
        view.addSubviews(banner, bgImage, mealLabel, typeLabel, dateStack, eatenStack)
        view.enableAutoLayout(bgImage, mealLabel, typeLabel, dateStack, eatenStack)
        
        configureBg()
        configureTitle()
        configureType()
        configureDateStack()
        configureEatenStack()
        if meal.type == K.MealFilter.order {
            configureOrdered()
        } else {
            configureCooked()
        }
    }
    
    
    private func configureUIData() {
        mealLabel = HeaderLabel(labelText: meal.name ?? "Name Not Found", labelFont: UIFont(name: K.Fonts.montserrat + K.Fonts.weight.bold, size: 32)!, wordWrap: true, color: UIColor(named: K.Color.red)!)
        typeLabel = HeaderLabel(labelText: meal.type ?? "Type Not Found", labelFont: UIFont(name: K.Fonts.openSans + K.Fonts.weight.bold, size: 20)!)
        
        if let date = meal.lastAte {
            let dateFormatter = K.formatDate(date)
            dateStack = HorizontalLabelsStack(leftText: "Eaten On:", rightText: dateFormatter.string(from: date))
        } else {
            dateStack = HorizontalLabelsStack(leftText: "Eaten On:", rightText: "--")
        }
        
        eatenStack = HorizontalLabelsStack(leftText: "Times Eaten:", rightText: "\(meal.numberOfTimesEaten)")
    }
    
    
    private func configureBg() {
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
            dateStack.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 25),
            dateStack.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: padding*multiplier),
            dateStack.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: -padding*multiplier),
            dateStack.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    
    private func configureEatenStack(withPadding padding: CGFloat = 10, multiplier: CGFloat = 4) {
        NSLayoutConstraint.activate([
            eatenStack.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: padding),
            eatenStack.leadingAnchor.constraint(equalTo: bgImage.leadingAnchor, constant: padding*multiplier),
            eatenStack.trailingAnchor.constraint(equalTo: bgImage.trailingAnchor, constant: -padding*multiplier),
            eatenStack.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    
    private func configureOrdered() {
    }
    
    private func configureCooked() {
        
    }
}
