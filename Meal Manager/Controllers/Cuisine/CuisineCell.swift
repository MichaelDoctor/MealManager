//
//  CuisineCell.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-18.
//

import UIKit
import CoreData

class CuisineCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cuisineSwitch: UISwitch!
    
    var cuisine = Cuisine()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: - Buttons

extension CuisineCell {
    //MARK: - Switch button
    @IBAction func cuisineSwitchTapped(_ sender: UISwitch) {
        updateActive()
    }
}


//MARK: - Core Data function

extension CuisineCell {
    //MARK: - Update
    func updateActive(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        cuisine.isActive = !cuisine.isActive
        do {
            try context.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
