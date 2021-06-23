//
//  AppDelegate.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-05.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // preload cuisine data
        preloadData()
        
        // IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        return true
    }
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    //MARK: - Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Meal_Manager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//MARK: - Custom
extension AppDelegate {
    //MARK: - PreloadedData
    private func preloadData() {
        let userDefaults = UserDefaults.standard
        
        // everytime app is installed
        if !userDefaults.bool(forKey: K.preloadKey) {
            // never loaded data. PreloadData and parse plist
            guard let urlPath = Bundle.main.url(forResource: "PreloadedCuisine", withExtension: "plist") else { return }
            let backgroundContext = persistentContainer.newBackgroundContext()
            persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            
            backgroundContext.perform {
                if let arrayContents = NSArray(contentsOf: urlPath) as? [String] {
                    for name in arrayContents {
                        let cuisine = Cuisine(context: backgroundContext)
                        cuisine.name = name
                        cuisine.isActive = true
                        cuisine.numberOfTimesEaten = 0
                    }
                    // save default cuisines
                    do {
                        try backgroundContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                // save values to userDefaults
                userDefaults.setValue(true, forKey: K.preloadKey)
            }
        }
    }
}
