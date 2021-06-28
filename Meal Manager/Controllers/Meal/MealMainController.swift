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
    private let banner: GADBannerView = GoogleAdMobManager.createBanner()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var overlayView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var playFilter: UIButton!
    @IBOutlet var infoButton: UIButton!
    var meals = [Meal]()
    var activeMeals = [Meal]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateView()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        GoogleAdMobManager.layoutAd(forView: view, tabBarController: tabBarController, banner: banner)
    }
}

//MARK: - Buttons

extension MealMainController {
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let sideMenuController = SideMenuNavigationController(rootViewController: MealAddMenuController())
        present(sideMenuController, animated: true)
    }
    
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        loadMeals()
        print("\(meals.count) meals loaded")
    }
    
    
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        let menu = storyboard!.instantiateViewController(withIdentifier: K.Views.mealRightMenu) as! SideMenuNavigationController
        present(menu, animated: true)
    }
    
    
    @IBAction func settingsButtonTapped(_ sender: UIBarButtonItem) {
        let sideMenuController = SideMenuNavigationController(rootViewController: MealLeftMenuController())
        sideMenuController.leftSide = true
        present(sideMenuController, animated: true)
    }
    
    
    @IBAction func filterTapped(_ sender: UIButton) {
        print("Filter tapped")
    }
    
    
    @IBAction func infoTapped(_ sender: UIButton) {
        let messageStyle = NSMutableParagraphStyle()
        messageStyle.alignment = .left
        let messageText = NSAttributedString(
            string: """
Add a custom meal:
    - Press the '+ icon' on the top right

Change the play filter:
    - Tap the button beside the '? icon' to return:
        - 'ALL' meals
        - only 'Cooked' type meals
        - or only 'Ordered' type meals

Play Button:
    - Tap the 'PLAY icon' to return a random meal that you have not eaten recently

Reset Recently Eaten:
    - Tap the 'GEAR icon' on the top left
    - Select 'Reset Eaten'

View Your Meals:
    - Tap the 'LIST icon' on the top right to view your meals
""",
            attributes: [
                NSAttributedString.Key.paragraphStyle: messageStyle,
                NSAttributedString.Key.foregroundColor : UIColor.black,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
            ]
        )
        let alert = UIAlertController(
            title: "About 'My Meals' tab",
            message: nil,
            preferredStyle: .alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

//MARK: - Core Data CRUD
extension MealMainController {
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
}

//MARK: - Configure Functions
extension MealMainController {
    private func configure() {
        configureBanner()
        overlayView.roundedView()
        playFilter.roundedButton(bg: UIColor(named: K.Color.accent)!, tint: .white)
    }
    
    
    private func configureBanner() {
        banner.rootViewController = self
        view.addSubview(banner)
    }
}

//MARK: - Animation
extension MealMainController {
    func animateView() {
        let animation = AnimationType.zoom(scale: 0.3)
        overlayView.animate(animations: [animation])
        titleLabel.animate(animations: [animation])
        bodyLabel.animate(animations: [animation])
        playButton.animate(animations: [animation])
        playFilter.animate(animations: [animation])
        infoButton.animate(animations: [animation])
    }
}
