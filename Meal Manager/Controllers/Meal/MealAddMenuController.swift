//
//  MealAddMenuController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-06-04.
//

import UIKit
import ViewAnimator
import CoreData

class MealAddMenuController: UITableViewController {
    
    let options = ["Add Cooked Meal","Add Ordered Meal"]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

//MARK: - UITableViewDataSource
extension MealAddMenuController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: K.Views.cuisineLeftCell)
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.textColor = UIColor(named: K.Color.red)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MealAddMenuController {
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch indexPath.row {
            case 0:
                addMeal(type: K.MealFilter.cook)
            case 1:
                addMeal(type: K.MealFilter.order)
            default:
                break
            }
        }
}

//MARK: - Core Data Create functions
extension MealAddMenuController {
    
}

//MARK: - Configure and Helper Functions
extension MealAddMenuController {
    private func configure() {
        tableView.removeExcessCells()
        navigationController?.isNavigationBarHidden = true
    }
    
    
    func addMeal(type: String) {
        let alert = UIAlertController(title: "\(type) Meal Creation", message: "Add the name of your meal", preferredStyle: .alert)
        alert.redActions()
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Add", style: .default) {
            [weak self] _ in
            guard let self = self else { return }
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            self.createMeal(name: text, type: type)
            self.dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }))
        present(alert, animated: true)
        
    }
    
    func createMeal(name: String, type: String, cuisineType: String = "Any") {
        let newMeal = Meal(context: context)
        newMeal.name = name
        newMeal.type = type
        // add image later
        newMeal.numberOfTimesEaten = 0
        newMeal.didEat = false
        newMeal.cuisineType = cuisineType
        
        if type == K.MealFilter.cook {
            newMeal.cookType = createCookType()
            newMeal.orderType = nil
        } else {
            newMeal.orderType = createOrderType()
            newMeal.cookType = nil
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createCookType() -> CookType {
        let cookType = CookType(context: context)
        cookType.ingredients = NSSet(array: [Ingredient]())
        cookType.instructions = NSSet(array: [Instruction]())
        return cookType
    }
    
    func createOrderType() -> OrderType {
        let orderType = OrderType(context: context)
        return orderType
    }
}

//MARK: - Right Slide Animation
extension MealAddMenuController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row)
        ) {
            cell.alpha = 1
            cell.transform = CGAffineTransform(translationX: -self.view.frame.width/2, y: 0)
        }
    }
}
