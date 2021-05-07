//
//  ListViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-06.
//

import UIKit
import GoogleMobileAds

class ListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // Core Data Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    var meals = [Meal]()
    var meals = [String]()
    
    // Google Admob banner
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        // replace later
        //        banner.adUnitID = "ca-app-pub-2009699556932262/
        // added to plist
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.load(GADRequest())
        //      banner.backgroundColor = .secondarySystemBackground
        banner.backgroundColor = .white
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        banner.rootViewController = self
        view.addSubview(banner)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottom = view.window!.frame.size.height
        let tabBarHeight = tabBarController!.tabBar.frame.size.height
        banner.frame = CGRect(x: 0, y: bottom-tabBarHeight-50, width: view.frame.size.width, height: 50).integral
    }
    
    @IBAction func leftNavButtonTapped(_ sender: UIBarButtonItem) {
        print("left tapped")
    }
    
    
    @IBAction func rightNavButtonTapped(_ sender: UIBarButtonItem) {
        print("right tapped")
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        print("filter tapped")
    }
    
    func loadMeals() {
        
    }
    
}

//MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if meals.isEmpty {
            // Will return a cell to tell the user to add a meal
            return 1
        } else {
            return meals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Views.cellIdentifier, for: indexPath)
        if meals.isEmpty {
            cell.textLabel?.text = "Add A Meal"
            cell.detailTextLabel?.text = "Tap the top left button"
            cell.textLabel?.textColor = .gray
            cell.detailTextLabel?.textColor = .lightGray
        } else {
            cell.textLabel?.text = meals[indexPath.row]
            cell.detailTextLabel?.text = "Order"
            cell.textLabel?.textColor = UIColor.init(named: K.Color.black)
            cell.detailTextLabel?.textColor = .gray
        }
        return cell
    }
}
