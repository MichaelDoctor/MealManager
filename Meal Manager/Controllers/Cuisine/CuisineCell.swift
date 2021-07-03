//
//  CuisineCell.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-18.
//

import UIKit
import CoreData

class CuisineCell: UITableViewCell {
    
    static let reuseID = K.Views.cuisineRightCell
    let title = UILabel()
    let uiSwitch = UISwitch()
    
    var cuisine: Cuisine!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Core Data function
extension CuisineCell {
    //MARK: - Update
    @objc func updateActive() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        cuisine.isActive = !cuisine.isActive
        
        do {
            try context.save()
            title.textColor = cuisine.isActive ? UIColor.init(named: K.Color.red) : UIColor.init(named: K.Color.black)
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Configure functions
extension CuisineCell {
    private func configure() {
        addSubviews(uiSwitch, title)
        configureUISwitch(withPadding: 10)
        configureTitle(withPadding: 10)
    }
    
    
    private func configureUISwitch(withPadding padding: CGFloat) {
        accessoryView = uiSwitch
        
        uiSwitch.addTarget(self, action: #selector(updateActive), for: .valueChanged)
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.onTintColor = UIColor(named: K.Color.accent)
        
        NSLayoutConstraint.activate([
            uiSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            uiSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            uiSwitch.heightAnchor.constraint(equalToConstant: 30),
            uiSwitch.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    
    private func configureTitle(withPadding padding: CGFloat) {
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 20)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.90
        title.lineBreakMode = .byTruncatingTail
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            title.trailingAnchor.constraint(equalTo: uiSwitch.leadingAnchor, constant: -padding),
            title.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
