//
//  TestViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-12.
//

import UIKit
import CoreData

class TestViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    
    // Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // meals = tableView, activeMeals for play button
    var meals = [Meal]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        // get meals
        loadMeals()
    }
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Filter", message: "Filter meals by type.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "All", style: .default))
        alert.addAction(UIAlertAction(title: "Cook", style: .default))
        alert.addAction(UIAlertAction(title: "Order", style: .default))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
}

extension TestViewController {
    //MARK: - Read
    func loadMeals(with request: NSFetchRequest<Meal> = Meal.fetchRequest(), predicate: NSPredicate? = nil) {
        
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

extension TestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if meals.isEmpty {
            // To tell the user to add meals
            return 1
        } else {
            return meals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Views.mealRightCell, for: indexPath)
        // Empty array
        if meals.isEmpty {
            cell.textLabel?.text = "No Meals Found"
            cell.detailTextLabel?.text = "Add Meals Using The Top Left Button or Edit Search."
            cell.textLabel?.textColor = .gray
            cell.detailTextLabel?.textColor = .lightGray
            cell.isUserInteractionEnabled = false
        } else {
            let meal = meals[indexPath.row]
            cell.textLabel?.text = meal.name
            cell.detailTextLabel?.text = meal.type
            cell.textLabel?.textColor = UIColor.init(named: K.Color.black)
            cell.detailTextLabel?.textColor = .gray
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
}

extension TestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(meals[indexPath.row].name)
    }
}

extension TestViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadMeals(with: request, predicate: NSPredicate(format: "name CONTAINS[cd] %@", text))
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if text.isEmpty {
            // reload all meals
            loadMeals()
        }
    }
}
