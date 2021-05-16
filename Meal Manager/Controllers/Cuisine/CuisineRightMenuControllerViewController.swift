//
//  CuisineRightMenuControllerViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-12.
//

import UIKit
import CoreData
import SideMenu

class CuisineRightMenuControllerViewController: UIViewController {
    var filterSetting = K.CuisineFilter.all
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cuisines = [Cuisine]()
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        // get Cuisines
        loadCuisines()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadCuisines()
    }
}

//MARK: - Core Data CRUD
extension CuisineRightMenuControllerViewController {
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
            self.cuisines = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    //MARK: - Update
    
    //MARK: - Delete
}

//MARK: - Filter Button
extension CuisineRightMenuControllerViewController {
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
}

//MARK: - UITableView

extension CuisineRightMenuControllerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cuisines.isEmpty {
            // Will return a cell to tell the user noting was found
            return 1
        } else {
            return cuisines.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Views.cuisineRightCell, for: indexPath)
        // Empty array
        if cuisines.isEmpty {
            cell.textLabel?.text = "No Results Found"
            cell.detailTextLabel?.text = "No matching cuisine was found."
            cell.textLabel?.textColor = .gray
            cell.detailTextLabel?.textColor = .lightGray
            cell.isUserInteractionEnabled = false
        } else {
            let cuisine = cuisines[indexPath.row]
            cell.textLabel?.text = cuisine.name
            cell.detailTextLabel?.text = cuisine.isActive ? "Enabled" : "Disabled"
            cell.textLabel?.textColor = UIColor.init(named: K.Color.black)
            cell.detailTextLabel?.textColor = .gray
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(identifier: K.Views.cuisineRightDetail) as? CuisineDetailViewController {
            
            detailViewController.cuisine = cuisines[indexPath.row]
            navigationController?.pushViewController(detailViewController, animated: true)
            
        }
//        let alert = UIAlertController(title: cuisine.name!, message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default) {
//            _ in
//            self.tableView.deselectRow(at: indexPath, animated: true)
//        })
//        alert.addAction(UIAlertAction(title: cuisine.isActive ? "Disable" : "Enable" , style: cuisine.isActive ? .destructive : .default) {
//            _ in
//            // edit active property
//            cuisine.isActive = !cuisine.isActive
//
//            // save
//            do {
//                try self.context.save()
//                self.searchBarSearchButtonClicked(self.searchBar)
//            } catch {
//                print(error.localizedDescription)
//            }
//            // reload table
//            //            self.loadCuisines()
//        })
//        present(alert, animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension CuisineRightMenuControllerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            loadCuisines()
            return }
        if text.isEmpty {
            loadCuisines()
            return
        }
        
        
        let request: NSFetchRequest<Cuisine> = Cuisine.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadCuisines(with: request, predicate: NSPredicate(format: "name CONTAINS[cd] %@", text))
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if text.isEmpty {
            loadCuisines()
        }
    }
}
