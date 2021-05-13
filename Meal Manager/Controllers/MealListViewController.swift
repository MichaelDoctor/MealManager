//
//  MealListViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-12.
//

import UIKit
import GoogleMobileAds
import CoreData
import SideMenu

class MealListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    // Core Data Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // meals = tableView, activeMeals for play button
    var meals = [Meal]()
    var activeMeals = [Meal]()
    
    // Google Admob banner
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        // replace later
        //        banner.adUnitID = "ca-app-pub-2009699556932262/
        // added to plist
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        DispatchQueue.global(qos: .background).async {
            banner.load(GADRequest())
        }
//        banner.load(GADRequest())
        //      banner.backgroundColor = .secondarySystemBackground
        banner.backgroundColor = .white
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        banner.rootViewController = self
        view.addSubview(banner)
        
        // get meals
        loadMeals()
    }
    
}

//MARK: - Core Data CRUD
extension MealListViewController {
    //MARK: - Create
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
            loadMeals()
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
            self.activeMeals = try context.fetch(notEatenRequest)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    //MARK: - Update
    
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

//MARK: - Left Navbar Button

extension MealListViewController {
    @IBAction func leftNavButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Add Eat In Meal", style: .default) {
            _ in
            self.addMeal(type: K.MealFilter.cook)
        })
        alert.addAction(UIAlertAction(title: "Add Eat Out Meal", style: .default) {
            _ in
            self.addMeal(type: K.MealFilter.order)
        })
        alert.addAction(UIAlertAction(title: "Reset Eaten", style: .default))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func addMeal(type: String) {
        // add drop down to choose from list of cuisine types
        let alert = UIAlertController(title: "\(type) Meal Creation", message: "Add a name for a basic meal", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Add", style: .default) {
            _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            self.createMeal(name: text, type: type)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

//MARK: - Right Navbar Button

extension MealListViewController {
    @IBAction func rightNavButtonTapped(_ sender: UIBarButtonItem) {
//        let alert = UIAlertController(title: "Right", message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        present(alert, animated: true)
        let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
        present(menu, animated: true)
    }
}

//MARK: - Filter Button

extension MealListViewController {
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Filter", message: "Filter meals by type.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "All", style: .default))
        alert.addAction(UIAlertAction(title: "Cook", style: .default))
        alert.addAction(UIAlertAction(title: "Order", style: .default))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension MealListViewController: UITableViewDataSource {
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

//MARK: - UITableViewDelegate

extension MealListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(meals[indexPath.row].name)
    }
}

//MARK: - UISearchBarDelegate

extension MealListViewController: UISearchBarDelegate {
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            // remove the meal
            self.deleteMeal(self.meals[indexPath.row])
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

//MARK: - Place Ad Banner

extension MealListViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Adjust size and position of ad banner
        let bottom = view.window!.frame.size.height
        let tabBarHeight = tabBarController!.tabBar.frame.size.height
        banner.frame = CGRect(x: 0, y: bottom-tabBarHeight-50, width: view.frame.size.width, height: 50).integral
    }
}
