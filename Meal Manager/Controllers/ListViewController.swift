//
//  ListViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-06.
//

import UIKit
import GoogleMobileAds
import CoreData

class ListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // Core Data Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    var meals = [Meal]()
    var cuisines = [Cuisine]()
    var activeCuisines = [Cuisine]()
    
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
        tableView.delegate = self
        
        banner.rootViewController = self
        view.addSubview(banner)
        
        // get Cuisines
        loadCuisines()
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
        let alert: UIAlertController
        // Check if its empty
        if !activeCuisines.isEmpty {
            let cuisine = activeCuisines.randomElement()?.name
            alert = UIAlertController(title: cuisine, message: "Try eating \(cuisine!)", preferredStyle: .alert)
        } else {
            //
            alert = UIAlertController(title: "Error", message: "Cuisine table is empty", preferredStyle: .alert)
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        print("filter tapped")
    }
    
    func loadCuisines(with request: NSFetchRequest<Cuisine> = Cuisine.fetchRequest(), predicate: NSPredicate? = nil) {
        // fetch data from Core Data
        do {
            // fetch for search bar req or grab all
            if let additionalPredicate = predicate {
                request.predicate = additionalPredicate
            }
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            // fetch active cuisines
            let activeRequest = Cuisine.fetchRequest() as NSFetchRequest<Cuisine>
            activeRequest.predicate = NSPredicate(format: "isActive == %@", NSNumber(value: true))
            
            // set all cuisines
            self.cuisines = try context.fetch(request)
            
            // set all enabled cuisines
            self.activeCuisines = try context.fetch(activeRequest)
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

//MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cuisines.isEmpty {
            // Will return a cell to tell the user to add a meal
            return 1
        } else {
            return cuisines.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Views.cellIdentifier, for: indexPath)
        if cuisines.isEmpty {
            cell.textLabel?.text = "Preloaded Data Error"
            cell.detailTextLabel?.text = "Cuisines Failed to load"
            cell.textLabel?.textColor = .gray
            cell.detailTextLabel?.textColor = .lightGray
        } else {
            let cuisine = cuisines[indexPath.row]
            cell.textLabel?.text = cuisine.name
            cell.detailTextLabel?.text = cuisine.isActive ? "Enabled" : "Disabled"
            cell.textLabel?.textColor = UIColor.init(named: K.Color.black)
            cell.detailTextLabel?.textColor = .gray
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cuisine = cuisines[indexPath.row]
        
        let alert = UIAlertController(title: cuisine.name!, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: cuisine.isActive ? "Disable" : "Enable" , style: cuisine.isActive ? .destructive : .default) {
            _ in
            // edit active property
            cuisine.isActive = !cuisine.isActive
            
            // save
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            // reload table
            self.loadCuisines()
        })
        present(alert, animated: true)
    }
    
}
