//
//  TestViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-12.
//

import UIKit
import CoreData
import ViewAnimator

class MealRightMenuController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var meals = [Meal]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

//MARK: - Buttons
extension MealRightMenuController {
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Filter", message: "Filter meals by type.", preferredStyle: .actionSheet)
        alert.redActions()
        alert.addAction(UIAlertAction(title: "All", style: .default))
        alert.addAction(UIAlertAction(title: "Cooked", style: .default))
        alert.addAction(UIAlertAction(title: "Ordered", style: .default))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

//MARK: - Core Data
extension MealRightMenuController {
    //MARK: - Read
    func loadMeals(with request: NSFetchRequest<Meal> = Meal.fetchRequest(), predicate: NSPredicate? = nil, doAnimate: Bool = true) {
        // fetch searchBar request
        if let additionalPredicate = predicate {
            request.predicate = additionalPredicate
        }
        
        // sort
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // fetch only meals that have not yet been eaten
        let notEatenRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        notEatenRequest.predicate = NSPredicate(format: "didEat == %@", NSNumber(value: false))
        
        do {
            self.meals = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if doAnimate {
                    self.animate()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Delete
    func deleteMeal(_ meal: Meal) {
        if meal.type == K.MealFilter.cook {
            context.delete(meal.cookType!)
        } else {
            context.delete(meal.orderType!)
        }
        
        context.delete(meal)
        
        // save the data
        do {
            try context.save()
            loadMeals()
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - UITableViewDataSource
extension MealRightMenuController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if meals.isEmpty {
            return 1
        } else {
            return meals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Views.mealRightCell, for: indexPath) as! MealCell
        // Empty array
        if meals.isEmpty {
            cell.title.text = "No Meals Found"
            cell.subtitle.text = "No meals found or match"
            cell.eaten.isHidden = true
            cell.title.textColor = .gray
            cell.subtitle.textColor = .lightGray
            cell.uiSwitch.isHidden = true
            cell.isUserInteractionEnabled = false
        } else {
            let meal = meals[indexPath.row]
            cell.meal = meal
            cell.title.text = meal.name
            cell.subtitle.text = meal.type
            cell.eaten.text = "Recently Eaten:"
            cell.title.textColor = meal.didEat ? UIColor.init(named: K.Color.black) : UIColor.init(named: K.Color.red)
            cell.subtitle.textColor = .gray
            cell.eaten.textColor = .gray
            cell.eaten.isHidden = false
            cell.uiSwitch.isHidden = false
            cell.uiSwitch.isOn = !meal.didEat
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MealRightMenuController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(meals[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        deleteMeal(meals[indexPath.row])
        
        if meals.isEmpty {
            tableView.reloadData()
        } else {
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

//MARK: - UISearchBarDelegate
extension MealRightMenuController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadMeals(with: request, predicate: NSPredicate(format: "name CONTAINS[cd] %@", text))
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if text.isEmpty {
            loadMeals()
        }
    }
}

//MARK: - Configure Functions
extension MealRightMenuController {
    private func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseID)
        tableView.removeExcessCells()
        
        searchBar.delegate = self
        navigationController?.isToolbarHidden = true
        loadMeals()
    }
}

//MARK: - Right Slide Animation
extension MealRightMenuController {
    func animate() {
        let animation = AnimationType.vector(CGVector(dx: self.view.frame.width / 2, dy: 0))
        UIView.animate(views: tableView.visibleCells, animations: [animation])
    }
}
