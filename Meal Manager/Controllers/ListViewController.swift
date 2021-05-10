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
    @IBOutlet var searchBar: UISearchBar!
    var filterSetting = K.CuisineFilter.all
    
    // Core Data Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // used for tableview
    var cuisines = [Cuisine]()
    // used for play button only
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
        
        searchBar.delegate = self
        
        banner.rootViewController = self
        view.addSubview(banner)
        
        // get Cuisines
        loadCuisines()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Adjust size and position of ad banner
        let bottom = view.window!.frame.size.height
        let tabBarHeight = tabBarController!.tabBar.frame.size.height
        banner.frame = CGRect(x: 0, y: bottom-tabBarHeight-50, width: view.frame.size.width, height: 50).integral
    }
    
    @IBAction func leftNavButtonTapped(_ sender: UIBarButtonItem) {
        print("Enable all or disable all option")
    }
    
    
    @IBAction func rightNavButtonTapped(_ sender: UIBarButtonItem) {
        
        // *****
        // Change to view push later
        // *****
        
        let alert: UIAlertController
        // Check if its empty
        if !activeCuisines.isEmpty {
            let cuisine = activeCuisines.randomElement()?.name
            alert = UIAlertController(title: cuisine, message: "Try eating \(cuisine!)", preferredStyle: .alert)
        } else {
            // active cuisines are empty
            alert = UIAlertController(title: "No Cuisines Found", message: "Please enable your preferred cuisines.", preferredStyle: .alert)
        }
        alert.addAction(UIAlertAction(title: "Eat", style: .default))
        alert.addAction(UIAlertAction(title: "Try Again", style: .destructive))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        
        
        // *****
        // Change to drop down later or sidemenu later
        // *****

        let alert = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "All", style: .default) {
            _ in
            // if the filterSetting was not already set to all
            if self.filterSetting != K.CuisineFilter.all {
                self.filterChanged(to: K.CuisineFilter.all)
            }
        })
        alert.addAction(UIAlertAction(title: "Enabled", style: .default) {
            _ in
            // if the filterSetting was not already set to enable
            if self.filterSetting != K.CuisineFilter.enable {
                self.filterChanged(to: K.CuisineFilter.enable)
            }
            
        })
        alert.addAction(UIAlertAction(title: "Disabled", style: .default) {
            _ in
            // if the filterSetting was not already set to disable
            if self.filterSetting != K.CuisineFilter.disable {
                self.filterChanged(to: K.CuisineFilter.disable)
            }
        })
        present(alert, animated: true)
    }
    
    // Called when the filter setting is changed
    func filterChanged(to filter: String) {
        self.filterSetting = filter
        self.searchBar.text = ""
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
        }
        self.loadCuisines()
    }
    
    // Populates our cuisine arrays
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
            // Will return a cell to tell the user noting was found
            return 1
        } else {
            return cuisines.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Views.cellIdentifier, for: indexPath)
        // Empty array
        if cuisines.isEmpty {
            cell.textLabel?.text = "No Results Found"
            cell.detailTextLabel?.text = "No matching cuisine was found."
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

//MARK: - UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // check its not nil
        guard let text = searchBar.text else { return }
        
        // request using Cuisine
        let request: NSFetchRequest<Cuisine> = Cuisine.fetchRequest()
        
        // sort
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // add predicate that returns Cuisine that contain the searchBar text
        loadCuisines(with: request, predicate: NSPredicate(format: "name CONTAINS[cd] %@", text))
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if text.isEmpty {
            // show all cuisines when empty
            loadCuisines()
        }
    }
}
