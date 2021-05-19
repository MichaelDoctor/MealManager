//
//  CuisineLeftMenuControllerTableViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-12.
//

import UIKit
import CoreData
import ViewAnimator

class CuisineLeftMenuController: UITableViewController {
    let options = ["Enable All Cuisine", "Disable All Cuisine", "Reset All Eaten Data"]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animate()
    }
}

//MARK: - Core Data functions
extension CuisineLeftMenuController {
    //MARK: - Update
    func updateBatchActive(value isActive: Bool) {
        // batch update Cuisine
        let request = NSBatchUpdateRequest(entityName: "Cuisine")
        // where cuisine is opposite of parameter
        request.predicate = NSPredicate(format: "isActive == %@", NSNumber(value: !isActive))
        // those that do not match the parameter are changed to mathc
        request.propertiesToUpdate = ["isActive": NSNumber(value: isActive)]
        request.resultType = .updatedObjectIDsResultType
        
        do {
            // attempt to  execute request
            let result = try self.context.execute(request) as! NSBatchUpdateResult
            // grab any changes
            let changes: [AnyHashable: Any] = [NSUpdatedObjectsKey: result.result as! [NSManagedObjectID]]
            // merge changes to context
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateBatchNumEaten() {
        // batch update Cuisine
        let request = NSBatchUpdateRequest(entityName: "Cuisine")
        // where numberOfTimesEaten > 0
        request.predicate = NSPredicate(format: "numberOfTimesEaten > %i", Int64(0))
        // those that are greater than 0 are changed to 0 and dates set to nil
        request.propertiesToUpdate = ["numberOfTimesEaten": Int64(0), "lastAte": Optional<Date>.none as Any]
        request.resultType = .updatedObjectIDsResultType
        
        do {
            // attempt to  execute request
            let result = try self.context.execute(request) as! NSBatchUpdateResult
            // grab any changes
            let changes: [AnyHashable: Any] = [NSUpdatedObjectsKey: result.result as! [NSManagedObjectID]]
            // merge changes to context
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Views.cuisineLeftCell, for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CuisineLeftMenuController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: options[indexPath.row], message: nil, preferredStyle: .alert)
        switch indexPath.row {
        case 0:
            alert.message = "All disabled cuisines will be enabled."
            alert.addAction(UIAlertAction(title: "Enable All", style: .default, handler: {
                _ in
                self.updateBatchActive(value: true)
                self.dismiss(animated: true)
            }))
        case 1:
            alert.message = "All enabled cuisines will be disabled."
            alert.addAction(UIAlertAction(title: "Disable All", style: .default, handler: {
                _ in
                self.updateBatchActive(value: false)
                self.dismiss(animated: true)
            }))
        case 2:
            alert.message = "Are you sure you want to reset the number of times eaten for all cuisines?"
            alert.addAction(UIAlertAction(title: "Reset Count", style: .destructive, handler: {
                _ in
                self.updateBatchNumEaten()
                self.dismiss(animated: true)
            }))
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

//MARK: - Left Slide Animation

extension CuisineLeftMenuController {
    func animate() {
        let animation = AnimationType.vector(CGVector(dx: -self.view.frame.width / 2, dy: 0))
        
        UIView.animate(views: tableView.visibleCells, animations: [animation])
    }
}

