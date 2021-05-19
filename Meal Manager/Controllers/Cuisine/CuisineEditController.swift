//
//  CuisineEditController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-18.
//

import UIKit
import Eureka

class CuisineEditController: FormViewController {

    var cuisine = Cuisine()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = cuisine.name
        
        form +++ Section("Edit \(cuisine.name!) data")
            <<< DateRow("lastAte") {
                row in
                row.title = "Eaten On"
                row.noValueDisplayText = "--"
                row.value = cuisine.lastAte
                
            }.cellUpdate {
                cell, row in
                if row.value != nil {
                    cell.textLabel?.textColor = .black
                } else {
                    cell.textLabel?.textColor = .gray
                }
            }
            <<< ButtonRow(){
                row in
                row.title = "Empty Eaten On"
                row.onCellSelection { _, _ in
                    let lastAte: DateRow? = self.form.rowBy(tag: "lastAte")
                    let numberOfTimesEaten: IntRow? = self.form.rowBy(tag: "numberOfTimesEaten")
                    lastAte?.value = nil
                    lastAte?.reload()
                    numberOfTimesEaten?.value = 0
                    numberOfTimesEaten?.reload()
                }
            }
            <<< IntRow("numberOfTimesEaten") {
                row in
                row.title = "#Eaten"
                row.placeholder = "Enter a positive number or 0"
                row.value = Cell<Int>.Value(cuisine.numberOfTimesEaten)
                row.add(rule: RuleRequired())
                row.add(rule: RuleGreaterOrEqualThan(min: 0))
            }.cellUpdate {
                cell, row in
                let submitBtn = self.form.rowBy(tag: "submit") as! ButtonRow
                if !row.isValid{
                    cell.titleLabel?.textColor = UIColor(named: K.Color.white)
                    cell.backgroundColor = UIColor(named: K.Color.accent)
                    row.placeholderColor = .lightGray
                    submitBtn.hidden = true
                } else {
                    cell.titleLabel?.textColor = UIColor(named: K.Color.black)
                    cell.backgroundColor = .white
                    submitBtn.hidden = false
                }
                submitBtn.evaluateHidden()
            }
        +++ Section()
            <<< ButtonRow("submit"){
                row in
                row.title = "Save"
                row.onCellSelection { _, _ in
                    let lastAte: DateRow? = self.form.rowBy(tag: "lastAte")
                    let numberOfTimesEaten: IntRow? = self.form.rowBy(tag: "numberOfTimesEaten")
                    if numberOfTimesEaten != nil {
                        self.updateCuisine(newDate: lastAte?.value as Date?, newNum: (numberOfTimesEaten?.value)! as Int)
                    }
                }
            }
    }


}

//MARK: - Core Data functions

extension CuisineEditController {
    func updateCuisine(newDate: Date?, newNum: Int) {
        cuisine.numberOfTimesEaten = Int64(newNum)
        cuisine.lastAte = newDate
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
}
