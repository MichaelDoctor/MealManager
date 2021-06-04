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
import ViewAnimator

class MealMainController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    
    // Core Data Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // meals = tableView, activeMeals for play button
    var meals = [Meal]()
    var activeMeals = [Meal]()
    
    // Google Admob banner
    private let banner: GADBannerView = K.createBanner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        banner.rootViewController = self
        view.addSubview(banner)
        
        // get meals
        loadMeals()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTitle()
    }
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    }
}

//MARK: - Buttons

extension MealMainController {
    //MARK: - Play Button
    @IBAction func playButtonTapped(_ sender: UIButton) {
//        if let playViewController = storyboard?.instantiateViewController(identifier: K.Views.cuisinePlay) as? CuisinePlayController {
//            loadCuisines()
//            var cuisine: Cuisine?
//            // Check if its empty
//            if !activeCuisines.isEmpty {
//                cuisine = activeCuisines.randomElement()
//                playViewController.cuisine = cuisine
//                playViewController.message = "Try eating \(cuisine!.name!) Cuisine"
//            } else {
//                // active cuisines are empty
//                playViewController.cuisine = nil
//                playViewController.message = "Please enable your preferred cuisines."
//            }
//            playViewController.parentController = self
//            navigationController?.showDetailViewController(playViewController, sender: self)
//        }
    }
    
    //MARK: - Left Navbar Button
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
    
    //MARK: - Right Navbar Button
    @IBAction func rightNavButtonTapped(_ sender: UIBarButtonItem) {
        let menu = storyboard!.instantiateViewController(withIdentifier: K.Views.mealRightMenu) as! SideMenuNavigationController
        
        present(menu, animated: true)
    }
}
//MARK: - Core Data CRUD
extension MealMainController {
    //MARK: - Create
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



//MARK: - Place Ad Banner

extension MealMainController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Adjust size and position of ad banner
        let bottom = view.window!.frame.size.height
        let tabBarHeight = tabBarController!.tabBar.frame.size.height
        banner.frame = CGRect(x: 0, y: bottom-tabBarHeight-50, width: view.frame.size.width, height: 50).integral
    }
}

//MARK: - Animation
extension MealMainController {
    func animateTitle() {
        let animation = AnimationType.zoom(scale: 0.3)
        titleLabel.animate(animations: [animation])
    }
}
