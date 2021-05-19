//
//  CuisineDetailViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-16.
//

import UIKit
import GoogleMobileAds

class CuisineDetailViewController: UIViewController {
    @IBOutlet var cuisineName: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var numLabel: UILabel!
    @IBOutlet var activeSwitch: UISwitch!
    
    var cuisine = Cuisine()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Google Admob banner
    private let banner: GADBannerView = K.createBanner()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        banner.rootViewController = self
        view.addSubview(banner)
        
        navigationController?.navigationBar.tintColor = UIColor(named: K.Color.white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
}

//MARK: - Buttons

extension CuisineDetailViewController {
    //MARK: - Edit button
    @IBAction func editTapped(_ sender: UIButton) {
        let editController = CuisineEditController(style: .insetGrouped)
        editController.cuisine = cuisine
        navigationController?.pushViewController(editController, animated: true)
    }
    
    //MARK: - Switch button
    @IBAction func switchTapped(_ sender: UISwitch) {
        updateActive()
    }
}

//MARK: - Core Data and UI functions

extension CuisineDetailViewController {
    //MARK: - Reload UI
    func loadData() {
        DispatchQueue.main.async {
            self.cuisineName.text = "\(self.cuisine.name!) Cuisine"
            
            self.activeSwitch.isOn = self.cuisine.isActive
            
            if let date = self.cuisine.lastAte {
                let dateFormatter = K.formatDate(date)
                self.dateLabel.text = dateFormatter.string(from: date)
            } else {
                self.dateLabel.text = "--"
            }
            
            self.numLabel.text = String(self.cuisine.numberOfTimesEaten)
        }
    }
    
    //MARK: - Update
    func updateActive() {
        cuisine.isActive = !cuisine.isActive
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Size and Place Ad Banner

extension CuisineDetailViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Adjust size and position of ad banner
        let bottom = view.window!.frame.size.height
        let tabBarHeight = tabBarController!.tabBar.frame.size.height
        banner.frame = CGRect(x: 0, y: bottom-tabBarHeight-50, width: view.frame.size.width, height: 50).integral
    }
}
