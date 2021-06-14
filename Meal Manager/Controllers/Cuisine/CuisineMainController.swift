//
//  ListViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-06.
//

import UIKit
import GoogleMobileAds
import CoreData
import SideMenu
import ViewAnimator

class CuisineMainController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    var filterSetting = K.CuisineFilter.all
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var activeCuisines = [Cuisine]()
    
    // Google Admob banner
    private let banner = GoogleAdMobManager.createBanner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        banner.rootViewController = self
        view.addSubview(banner)
        
        FindLocationManager.shared.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTitle()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        GoogleAdMobManager.layoutAd(forView: view, tabBarController: tabBarController, banner: banner)
    }
}

//MARK: - Buttons

extension CuisineMainController {
    //MARK: - Left Menu
    @IBAction func leftNavButtonTapped(_ sender: UIBarButtonItem) {
        let menu = storyboard!.instantiateViewController(withIdentifier: K.Views.cuisineLeftMenu) as! SideMenuNavigationController
        present(menu, animated: true)
    }
    
    //MARK: - Right Menu
    @IBAction func rightNavButtonTapped(_ sender: UIBarButtonItem) {
        let menu = storyboard!.instantiateViewController(withIdentifier: K.Views.cuisineRightMenu) as! SideMenuNavigationController
        present(menu, animated: true)
    }
    
    //MARK: - Play Button
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if let playViewController = storyboard?.instantiateViewController(identifier: K.Views.cuisinePlay) as? CuisinePlayController {
            loadCuisines()
            var cuisine: Cuisine?
            // Check if its empty
            if !activeCuisines.isEmpty {
                cuisine = activeCuisines.randomElement()
                playViewController.cuisine = cuisine
                playViewController.message = "Try eating \(cuisine!.name!) Cuisine"
            } else {
                // active cuisines are empty
                playViewController.cuisine = nil
                playViewController.message = "Please enable your preferred cuisines."
            }
            playViewController.parentController = self
            let navController = UINavigationController(rootViewController: playViewController)
            present(navController, animated: true)
        }
    }
}
//MARK: - Core Data functions

extension CuisineMainController {
    //MARK: - Read
    func loadCuisines() {
        // fetch data from Core Data
        do {
            // fetch active cuisines. Used only for the play button.
            let activeRequest: NSFetchRequest<Cuisine> = Cuisine.fetchRequest()
            activeRequest.predicate = NSPredicate(format: "isActive == %@", NSNumber(value: true))
            
            // set all enabled cuisines
            self.activeCuisines = try context.fetch(activeRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Update
    func updateCuisine(cuisine: Cuisine, newNum: Int) {
        cuisine.numberOfTimesEaten = Int64(newNum)
        cuisine.lastAte = Date()
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Animation

extension CuisineMainController {
    func animateTitle() {
        let animation = AnimationType.zoom(scale: 0.3)
        titleLabel.animate(animations: [animation])
    }
}




