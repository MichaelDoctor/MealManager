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
    var filterSetting = K.MealFilter.all
    
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
        // basic functionality
        loadMeals()
        var meal: Meal?
        
        if !meals.isEmpty {
            meal = meals.randomElement()
            print(meal!.name ?? "No Name")
            let nav = UINavigationController(rootViewController: MealPlayController())
            present(nav, animated: true)
        } else {
            print("Add meals")
        }
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
        let alert = UIAlertController(title: "Change Play Filter", message: "Return ALL uneaten meals or only a specific type.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: K.MealFilter.all.uppercased(), style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.changeFilter(to: K.MealFilter.all)
        }))
        alert.addAction(UIAlertAction(title: K.MealFilter.cook.uppercased(), style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.changeFilter(to: K.MealFilter.cook)
        })
        alert.addAction(UIAlertAction(title: K.MealFilter.order.uppercased(), style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.changeFilter(to: K.MealFilter.order)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
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
    func loadMeals(with request: NSFetchRequest<Meal> = Meal.fetchRequest()) {
        var filterPredicate: NSPredicate? = nil
        
        if filterSetting != K.MealFilter.all {
            filterPredicate = NSPredicate(format: "type == %@", filterSetting)
        }
        
        let notEatenPredicate = NSPredicate(format: "didEat == %@", NSNumber(value: false))
        
        if let filterPredicate = filterPredicate {
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [notEatenPredicate, filterPredicate])
        } else {
            request.predicate = notEatenPredicate
        }
        
        do {
            self.meals = try context.fetch(request)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Configure and Helper Functions
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
    
    func changeFilter(to filter: String) {
        filterSetting = filter
        DispatchQueue.main.async {
            self.playFilter.setTitle(filter.uppercased(), for: .normal)
        }
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
