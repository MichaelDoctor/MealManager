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
    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView(frame: .zero)
    
    var mealLabel: HeaderLabel!
    var typeLabel: HeaderLabel!
    var dateStack: HorizontalLabelsStack!
    var eatenStack: HorizontalLabelsStack!
    var addressStack: HorizontalLabelButtonStack?
    var linkStack: HorizontalLabelButtonStack?
    var meal: Meal!
    var contentViewHeight: CGFloat = 130
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAdMobManager.layoutAd(forView: view, tabBarController: tabBarController)
        configureContentHeight()
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
    
    
    @objc func addressButtonTapped() {
        print("Address Tapped")
    }
    
    
    @objc func linkButtonTapped() {
        print("Link Tapped")
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

        view.addSubviews(bgImage, scrollView, banner)
        scrollView.addSubview(contentView)
        
        view.enableAutoLayout(bgImage, scrollView, contentView, mealLabel, typeLabel, dateStack, eatenStack)
        contentView.addSubviews(mealLabel, typeLabel, dateStack, eatenStack)
        
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
            bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    
    private func configureTitle(withPadding padding: CGFloat = 10, multiplier: CGFloat = 4) {
        NSLayoutConstraint.activate([
            mealLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 75),
            mealLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mealLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            mealLabel.heightAnchor.constraint(equalToConstant: 125),
        ])
    }
    
    
    private func configureType(withPadding padding: CGFloat = 10, multiplier: CGFloat = 4) {
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: mealLabel.bottomAnchor, constant: padding),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding*multiplier),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding*multiplier),
            typeLabel.heightAnchor.constraint(equalToConstant: (meal != nil) ? 25 : 75)
        ])
    }
    
    
    private func configureDateStack(withPadding padding: CGFloat = 10, multiplier: CGFloat = 4) {
        NSLayoutConstraint.activate([
            dateStack.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 25),
            dateStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding*multiplier),
            dateStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding*multiplier),
            dateStack.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    
    private func configureEatenStack(withPadding padding: CGFloat = 10, multiplier: CGFloat = 4) {
        NSLayoutConstraint.activate([
            eatenStack.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: padding),
            eatenStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding*multiplier),
            eatenStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding*multiplier),
            eatenStack.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    
    private func configureOrdered(withPadding padding: CGFloat = 10, multiplier: CGFloat = 4) {
        if let address = meal.orderType?.address {
            addressStack = HorizontalLabelButtonStack(leftText: "Address:", rightText: address)
        } else {
            addressStack = HorizontalLabelButtonStack(leftText: "Address:", rightText: "--")
            addressStack?.rightButton.setTitleColor(UIColor(named: K.Color.black), for: .normal)
            addressStack?.rightButton.isUserInteractionEnabled = false
        }
        
        if let link = meal.orderType?.link {
            linkStack = HorizontalLabelButtonStack(leftText: "Link:", rightText: link)
        } else {
            linkStack = HorizontalLabelButtonStack(leftText: "Link:", rightText: "--")
            linkStack?.rightButton.setTitleColor(UIColor(named: K.Color.black), for: .normal)
            linkStack?.rightButton.isUserInteractionEnabled = false
        }
        
        guard let addressStack = addressStack, let linkStack = linkStack else { return }
        
        addressStack.rightButton.addTarget(self, action: #selector(addressButtonTapped), for: .touchUpInside)
        linkStack.rightButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        contentView.addSubviews(addressStack, linkStack)
        view.enableAutoLayout(addressStack, linkStack)
        
        NSLayoutConstraint.activate([
            addressStack.topAnchor.constraint(equalTo: eatenStack.bottomAnchor, constant: padding),
            addressStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding*multiplier),
            addressStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding*multiplier),
            addressStack.heightAnchor.constraint(equalToConstant: 25),
            
            linkStack.topAnchor.constraint(equalTo: addressStack.bottomAnchor, constant: padding),
            linkStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding*multiplier),
            linkStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding*multiplier),
            linkStack.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    
    private func configureCooked() {
        
    }
    
    
    func configureContentHeight() {
        for view in contentView.subviews {
            contentViewHeight += view.frame.size.height + 10
        }
        if contentViewHeight > view.frame.size.height - 50 {
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: contentViewHeight)
        }
    }
}
