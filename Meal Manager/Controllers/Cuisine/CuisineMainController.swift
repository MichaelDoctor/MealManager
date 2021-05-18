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

class CuisineMainController: UIViewController {
    var filterSetting = K.CuisineFilter.all
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // used for play button only
    var activeCuisines = [Cuisine]()
    
    // Google Admob banner
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        // replace later
        //        banner.adUnitID = "ca-app-pub-2009699556932262/4104921805"
        // added to plist
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        DispatchQueue.global(qos: .background).async {
            banner.load(GADRequest())
        }
        banner.backgroundColor = .white
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        banner.rootViewController = self
        view.addSubview(banner)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if let playViewController = storyboard?.instantiateViewController(identifier: K.Views.cuisinePlay) as? CuisinePlayController {
            loadCuisines()
            var cuisine: Cuisine?
            // Check if its empty
            if !activeCuisines.isEmpty {
                cuisine = activeCuisines.randomElement()
                playViewController.cuisine = cuisine
                playViewController.message = "Try eating \(cuisine!.name!)"
            } else {
                // active cuisines are empty
                playViewController.cuisine = nil
                playViewController.message = "Please enable your preferred cuisines."
            }
            playViewController.parentController = self
            navigationController?.showDetailViewController(playViewController, sender: self)
        }
    }
}

//MARK: - Core Data Related functions

extension CuisineMainController {
    //MARK: - Read
    
    func loadCuisines(with request: NSFetchRequest<Cuisine> = Cuisine.fetchRequest(), predicate: NSPredicate? = nil) {
        // fetch data from Core Data
        do {
            var filterPredicate: NSPredicate? = nil
            
            if filterSetting != K.CuisineFilter.all {
                let isActive = filterSetting == K.CuisineFilter.enable ? true : false
                filterPredicate = NSPredicate(format: "isActive == %@", NSNumber(value: isActive))
            }
            
            // Fetch for searchBar request, filterRequest, or both
            if let additionalPredicate = predicate, let filter = filterPredicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [filter, additionalPredicate])
            } else if let additionalPredicate = predicate {
                request.predicate = additionalPredicate
            } else if let filter = filterPredicate {
                request.predicate = filter
            }
            
            // sort ascending order
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            // fetch active cuisines. Used only for the play button.
            let activeRequest: NSFetchRequest<Cuisine> = Cuisine.fetchRequest()
            activeRequest.predicate = NSPredicate(format: "isActive == %@", NSNumber(value: true))
            
            // set all cuisines
            
            // set all enabled cuisines
            self.activeCuisines = try context.fetch(activeRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Update
    
    func updateCuisine(cuisine: Cuisine, newNum: Int) {
        cuisine.numberOfTimesEaten = Int64(newNum)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Size and Place Ad Banner

extension CuisineMainController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Adjust size and position of ad banner
        let bottom = view.window!.frame.size.height
        let tabBarHeight = tabBarController!.tabBar.frame.size.height
        banner.frame = CGRect(x: 0, y: bottom-tabBarHeight-50, width: view.frame.size.width, height: 50).integral
    }
}

//MARK: - Left Menu Button

extension CuisineMainController {
    @IBAction func leftNavButtonTapped(_ sender: UIBarButtonItem) {
        let menu = storyboard!.instantiateViewController(withIdentifier: K.Views.cuisineLeftMenu) as! SideMenuNavigationController
        present(menu, animated: true)
    }
}
//MARK: - Right Menu

extension CuisineMainController {
    @IBAction func rightNavButtonTapped(_ sender: UIBarButtonItem) {
        let menu = storyboard!.instantiateViewController(withIdentifier: K.Views.cuisineRightMenu) as! SideMenuNavigationController
        present(menu, animated: true)
    }
}



