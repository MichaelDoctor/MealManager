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
    @IBOutlet var isActiveLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var numLabel: UILabel!
    
    var cuisine = Cuisine()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        navigationController?.navigationBar.tintColor = UIColor(named: K.Color.white)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        DispatchQueue.main.async {
            self.cuisineName.text = "\(self.cuisine.name!) Cuisine"
            self.isActiveLabel.text = self.cuisine.isActive ? "Enabled" : "Disabled"
            
            if let date = self.cuisine.lastAte {
                let dateFormatter = K.formatDate(date)
                self.dateLabel.text = dateFormatter.string(from: date)
            } else {
                self.dateLabel.text = "--"
            }
            
            self.numLabel.text = String(self.cuisine.numberOfTimesEaten)
        }
    }

    @objc func editTapped() {
        let editController = CuisineEditController(style: .insetGrouped)
        editController.cuisine = cuisine
        navigationController?.pushViewController(editController, animated: true)
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
