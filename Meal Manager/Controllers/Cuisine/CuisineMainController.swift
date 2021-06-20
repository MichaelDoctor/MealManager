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
    
    private let banner = GoogleAdMobManager.createBanner()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var overlayView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    var filterSetting = K.CuisineFilter.all
    var activeCuisines = [Cuisine]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBanner()
        overlayView.roundedView()
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
    //MARK: - Left Side Menu
    @IBAction func leftNavButtonTapped(_ sender: UIBarButtonItem) {
        let sideMenuController = SideMenuNavigationController(rootViewController: CuisineLeftMenuController())
        sideMenuController.leftSide = true
        present(sideMenuController, animated: true)
    }
    
    //MARK: - Right Side Menu
    @IBAction func rightNavButtonTapped(_ sender: UIBarButtonItem) {
        let menu = storyboard!.instantiateViewController(withIdentifier: K.Views.cuisineRightMenu) as! SideMenuNavigationController
        present(menu, animated: true)
    }
    
    //MARK: - Play Button
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if let playViewController = storyboard?.instantiateViewController(identifier: K.Views.cuisinePlay) as? CuisinePlayController {
            loadCuisines()
            var cuisine: Cuisine?
            
            if !activeCuisines.isEmpty {
                cuisine = activeCuisines.randomElement()
                playViewController.cuisine = cuisine
                playViewController.message = "Try eating \(cuisine!.name!) Cuisine"
            } else {
                playViewController.cuisine = nil
                playViewController.message = "Please enable your preferred cuisines."
            }
            //
            
            
            // Change this to delegate
            
            //
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
        do {
            let activeRequest: NSFetchRequest<Cuisine> = Cuisine.fetchRequest()
            activeRequest.predicate = NSPredicate(format: "isActive == %@", NSNumber(value: true))
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

//MARK: - Configure Functions
extension CuisineMainController {
    
    private func configureBanner() {
        banner.rootViewController = self
        view.addSubview(banner)
    }
}

//MARK: - Animation
extension CuisineMainController {
    
    func animateTitle() {
        let animation = AnimationType.zoom(scale: 0.3)
        overlayView.animate(animations: [animation])
        titleLabel.animate(animations: [animation])
        bodyLabel.animate(animations: [animation])
        playButton.animate(animations: [animation])
    }
}




