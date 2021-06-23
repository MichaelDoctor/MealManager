//
//  CuisineLeftMenuControllerTableViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-12.
//

import UIKit
import CoreData
import ViewAnimator
import SideMenu

class CuisineLeftMenuController: UITableViewController {
    
    let options = ["Enable All Cuisine", "Disable All Cuisine", "Reset All Eaten Data"]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

//MARK: - Core Data functions
extension CuisineLeftMenuController {
    //MARK: - Update
    func updateBatchActive(value isActive: Bool) {
        let request = NSBatchUpdateRequest(entityName: "Cuisine")
        request.predicate = NSPredicate(format: "isActive == %@", NSNumber(value: !isActive))
        request.propertiesToUpdate = ["isActive": NSNumber(value: isActive)]
        request.resultType = .updatedObjectIDsResultType
        
        do {
            let result = try self.context.execute(request) as! NSBatchUpdateResult
            
            let changes: [AnyHashable: Any] = [NSUpdatedObjectsKey: result.result as! [NSManagedObjectID]]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func updateBatchNumEaten() {
        let request = NSBatchUpdateRequest(entityName: "Cuisine")
        request.predicate = NSPredicate(format: "numberOfTimesEaten > %i", Int64(0))
        request.propertiesToUpdate = ["numberOfTimesEaten": Int64(0), "lastAte": Optional<Date>.none as Any]
        request.resultType = .updatedObjectIDsResultType
        
        do {
            let result = try self.context.execute(request) as! NSBatchUpdateResult

            let changes: [AnyHashable: Any] = [NSUpdatedObjectsKey: result.result as! [NSManagedObjectID]]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - UITableViewDataSource
extension CuisineLeftMenuController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: K.Views.cuisineLeftCell)
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.textColor = UIColor(named: K.Color.accent)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CuisineLeftMenuController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: options[indexPath.row], message: nil, preferredStyle: .alert)
        
        switch indexPath.row {
        case 0:
            enableAllCuisine(alert)
        case 1:
            disableAllCuisine(alert)
        case 2:
            resetEatenCounts(alert)
        default:
            break
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {
            _ in
            self.tableView.deselectRow(at: indexPath, animated: true)
        })
        present(alert, animated: true)
    }
}

//MARK: - Configure and helper Functions
extension CuisineLeftMenuController {
    private func configure() {
        tableView.removeExcessCells()
        navigationController?.isNavigationBarHidden = true
    }
    
    
    func enableAllCuisine(_ alert: UIAlertController) {
        alert.message = "All disabled cuisines will be enabled."
        alert.addAction(UIAlertAction(title: "Enable All", style: .default, handler: {
            [weak self] _ in
            guard let self = self else { return }
            self.updateBatchActive(value: true)
            self.dismiss(animated: true)
        }))
    }
    
    
    func disableAllCuisine(_ alert: UIAlertController) {
        alert.message = "All enabled cuisines will be disabled."
        alert.addAction(UIAlertAction(title: "Disable All", style: .default, handler: {
            [weak self] _ in
            guard let self = self else { return }
            self.updateBatchActive(value: false)
            self.dismiss(animated: true)
        }))
    }
    
    
    func resetEatenCounts(_ alert: UIAlertController) {
        alert.message = "Are you sure you want to reset the number of times eaten for all cuisines?"
        alert.addAction(UIAlertAction(title: "Reset Count", style: .destructive, handler: {
            [weak self] _ in
            guard let self = self else { return }
            self.updateBatchNumEaten()
            self.dismiss(animated: true)
        }))
    }
}

//MARK: - Left Slide Animation
extension CuisineLeftMenuController  {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row)
        ) {
            cell.alpha = 1
            cell.transform = CGAffineTransform(translationX: self.view.frame.width/2, y: 0)
        }
    }
}

