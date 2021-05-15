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
        
        banner.rootViewController = self
        view.addSubview(banner)
        
        // get Cuisines
        loadCuisines()
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        // *****
        // Change to view push later
        // *****
        
        let alert: UIAlertController
        var cuisine: Cuisine?
        // Check if its empty
        if !activeCuisines.isEmpty {
            cuisine = activeCuisines.randomElement()
            alert = UIAlertController(title: cuisine!.name, message: "Try eating \(cuisine!.name!)", preferredStyle: .alert)
        } else {
            // active cuisines are empty
            alert = UIAlertController(title: "No Cuisines Found", message: "Please enable your preferred cuisines.", preferredStyle: .alert)
        }
        alert.addAction(UIAlertAction(title: "Eat", style: .default) {
            _ in
            guard cuisine != nil else { return }
            self.updateCuisine(cuisine: cuisine!, newNum: Int(cuisine!.numberOfTimesEaten) + 1)
        })
        alert.addAction(UIAlertAction(title: "Try Again", style: .destructive) {
            _ in
            self.playButtonTapped(sender)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
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
//            self.cuisines = try context.fetch(request)
            
            // set all enabled cuisines
            self.activeCuisines = try context.fetch(activeRequest)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Update
    
//    func updateBatchActive(value isActive: Bool) {
//        // batch update Cuisine
//        let request = NSBatchUpdateRequest(entityName: "Cuisine")
//        // where cuisine is opposite of parameter
//        request.predicate = NSPredicate(format: "isActive == %@", NSNumber(value: !isActive))
//        // those that do not match the parameter are changed to mathc
//        request.propertiesToUpdate = ["isActive": NSNumber(value: isActive)]
//        request.resultType = .updatedObjectIDsResultType
//
//        do {
//            // attempt to  execute request
//            let result = try self.context.execute(request) as! NSBatchUpdateResult
//            // grab any changes
//            let changes: [AnyHashable: Any] = [NSUpdatedObjectsKey: result.result as! [NSManagedObjectID]]
//            // merge changes to context
//            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
//            // reload data to match merged context changes if any
//            self.filterChanged(to: K.CuisineFilter.all)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
//    func updateBatchNumEaten() {
//        // batch update Cuisine
//        let request = NSBatchUpdateRequest(entityName: "Cuisine")
//        // where numberOfTimesEaten > 0
//        request.predicate = NSPredicate(format: "numberOfTimesEaten > %i", Int64(0))
//        // those that are greater than 0 are changed to 0
//        request.propertiesToUpdate = ["numberOfTimesEaten": Int64(0)]
//        request.resultType = .updatedObjectIDsResultType
//
//        do {
//            // attempt to  execute request
//            let result = try self.context.execute(request) as! NSBatchUpdateResult
//            // grab any changes
//            let changes: [AnyHashable: Any] = [NSUpdatedObjectsKey: result.result as! [NSManagedObjectID]]
//            // merge changes to context
//            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
//            // reload data to match merged context changes if any
//            self.filterChanged(to: K.CuisineFilter.all)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
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



