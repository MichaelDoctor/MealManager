//
//  CuisineRightMenuControllerViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-12.
//

import UIKit
import CoreData
import ViewAnimator

class CuisineRightMenuController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var cuisines = [Cuisine]()
    var filterSetting = K.CuisineFilter.all
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableAndSearch()
        loadCuisines()
    }
}

//MARK: - Core Data functions
extension CuisineRightMenuController {
    //MARK: - Read
    func loadCuisines(with request: NSFetchRequest<Cuisine> = Cuisine.fetchRequest(), predicate: NSPredicate? = nil, doAnimate: Bool = true) {
        
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
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            self.cuisines = try K.context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if doAnimate {
                    self.animate()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Update
    func updateActive(_ cuisine: Cuisine) {
        cuisine.isActive = !cuisine.isActive
        do {
            try K.context.save()
            searchBarSearchButtonClicked(searchBar)
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Buttons
extension CuisineRightMenuController {
    //MARK: - Filter button
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Filter", message: nil, preferredStyle: .actionSheet)
        alert.redActions()
        alert.addAction(UIAlertAction(title: "All", style: .default) {
            [weak self] _ in
            guard let self = self else { return }
            if self.filterSetting != K.CuisineFilter.all {
                self.filterChanged(to: K.CuisineFilter.all)
            }
        })
        alert.addAction(UIAlertAction(title: "Enabled", style: .default) {
            [weak self] _ in
            guard let self = self else { return }
            if self.filterSetting != K.CuisineFilter.enable {
                self.filterChanged(to: K.CuisineFilter.enable)
            }
            
        })
        alert.addAction(UIAlertAction(title: "Disabled", style: .default) {
            [weak self] _ in
            guard let self = self else { return }
            if self.filterSetting != K.CuisineFilter.disable {
                self.filterChanged(to: K.CuisineFilter.disable)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    
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
extension CuisineRightMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cuisines.isEmpty {
            return 1
        } else {
            return cuisines.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Views.cuisineRightCell, for: indexPath) as! CuisineCell
        
        if cuisines.isEmpty {
            cell.title.text = "No Results Found"
            cell.title.textColor = .gray
            cell.uiSwitch.isHidden = true
            cell.isUserInteractionEnabled = false
        } else {
            let cuisine = cuisines[indexPath.row]
            cell.cuisine = cuisine
            cell.title.text = cuisine.name
            cell.title.textColor = cuisine.isActive ? UIColor.init(named: K.Color.red) : UIColor.init(named: K.Color.black)
            cell.uiSwitch.isHidden = false
            cell.uiSwitch.isOn = cuisine.isActive
            cell.isUserInteractionEnabled = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(identifier: K.Views.cuisineRightDetail) as? CuisineDetailViewController {
            detailViewController.cuisine = cuisines[indexPath.row]
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

//MARK: - UISearchBarDelegate
extension CuisineRightMenuController: UISearchBarDelegate {
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

//MARK: - Configure Functions
extension CuisineRightMenuController {
    private func configureTableAndSearch() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CuisineCell.self, forCellReuseIdentifier: CuisineCell.reuseID)
        tableView.removeExcessCells()
        
        searchBar.delegate = self
    }
}

//MARK: - Right Slide Animation
extension CuisineRightMenuController {
    func animate() {
        let animation = AnimationType.vector(CGVector(dx: self.view.frame.width / 2, dy: 0))
        UIView.animate(views: tableView.visibleCells, animations: [animation])
    }
}
