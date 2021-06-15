//
//  CuisineDetailViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-16.
//

import UIKit
import GoogleMobileAds

class CuisineDetailViewController: UIViewController {
    
    private let banner: GADBannerView = GoogleAdMobManager.sharedForDetail
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let locationManager = FindLocationManager.shared
    
    var cuisine = Cuisine()
    
    @IBOutlet var cuisineName: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var numLabel: UILabel!
    @IBOutlet var activeSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        banner.rootViewController = self
        view.addSubview(banner)
        
        navigationItem.rightBarButtonItem = nil
        navigationController?.navigationBar.tintColor = UIColor(named: K.Color.white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        GoogleAdMobManager.layoutAd(forView: view, tabBarController: tabBarController)
    }
}

//MARK: - Buttons

extension CuisineDetailViewController {
    @IBAction func nearMeTapped(_ sender: UIButton) {
        locationManager.findBestNearMe(forVC: self, cuisine: cuisine)
    }
    
    
    @IBAction func editTapped(_ sender: UIButton) {
        let editController = CuisineEditController(style: .insetGrouped)
        editController.cuisine = cuisine
        navigationController?.pushViewController(editController, animated: true)
    }
    
    
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
