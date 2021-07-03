//
//  MealCell.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-07-02.
//

import UIKit

class MealCell: UITableViewCell {
    
    static let reuseID = K.Views.mealRightCell
    let title = UILabel()
    let subtitle = UILabel()
    let eaten = UILabel()
    let uiSwitch = UISwitch()
    
    var meal: Meal!

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Core Data Functions
extension MealCell {
    //MARK: - Update
    @objc func updateEaten() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        meal.didEat = !meal.didEat
        
        do {
            try context.save()
            title.textColor = meal.didEat ? UIColor.init(named: K.Color.black) : UIColor.init(named: K.Color.red)
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Configure Functions
extension MealCell {
    private func configure() {
        addSubviews(title, subtitle, eaten, uiSwitch)
        enableAutoLayout(title, subtitle, eaten, uiSwitch)
        
        configureTitle()
        configureSubtitle()
        configureSwitch()
        configureEaten()
    }
    
    
    private func configureTitle(withPadding padding: CGFloat = 10) {
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 18)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.75
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            title.trailingAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    
    private func configureSubtitle(withPadding padding: CGFloat = 10) {
        subtitle.textAlignment = .left
        subtitle.font = UIFont.systemFont(ofSize: 14)
        subtitle.adjustsFontSizeToFitWidth = true
        subtitle.minimumScaleFactor = 0.90
        subtitle.lineBreakMode = .byWordWrapping
        subtitle.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: padding/2),
            subtitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            subtitle.trailingAnchor.constraint(equalTo: self.centerXAnchor),
            subtitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding/2)
        ])
    }
    
    
    private func configureEaten(withPadding padding: CGFloat = 10) {
        eaten.textAlignment = .right
        eaten.font = UIFont.systemFont(ofSize: 10, weight: .light)
        eaten.adjustsFontSizeToFitWidth = true
        eaten.minimumScaleFactor = 0.90
        eaten.lineBreakMode = .byWordWrapping
        eaten.numberOfLines = 0
        NSLayoutConstraint.activate([
            eaten.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            eaten.trailingAnchor.constraint(equalTo: uiSwitch.leadingAnchor, constant: -padding),
            eaten.leadingAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    
    private func configureSwitch(withPadding padding: CGFloat = 10) {
        accessoryView = uiSwitch
        
        uiSwitch.addTarget(self, action: #selector(updateEaten), for: .valueChanged)
        uiSwitch.onTintColor = UIColor(named: K.Color.accent)
        
        NSLayoutConstraint.activate([
            uiSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            uiSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            uiSwitch.heightAnchor.constraint(equalToConstant: 30),
            uiSwitch.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
