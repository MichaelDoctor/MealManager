//
//  CuisineLeftMenuControllerTableViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-12.
//

import UIKit
import CoreData

class CuisineLeftMenuControllerTableViewController: UITableViewController {
    
    let options = ["Enable All Cuisine", "Disable All Cuisine", "Reset All Eaten Data"]
    
    // Core Data Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

//MARK: - Core Data CRUD
extension CuisineLeftMenuControllerTableViewController {
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
        // those that are greater than 0 are changed to 0
        request.propertiesToUpdate = ["numberOfTimesEaten": Int64(0)]
        request.resultType = .updatedObjectIDsResultType
        
        do {
            // attempt to  execute request
            let result = try self.context.execute(request) as! NSBatchUpdateResult
            // grab any changes
            let changes: [AnyHashable: Any] = [NSUpdatedObjectsKey: result.result as! [NSManagedObjectID]]
            // merge changes to context
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            // reload data to match merged context changes if any
//            self.filterChanged(to: K.CuisineFilter.all)
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - UITableViewDataSource
extension CuisineLeftMenuControllerTableViewController {
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

extension CuisineLeftMenuControllerTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(options[indexPath.row])
        switch indexPath.row {
        case 0:
            updateBatchActive(value: true)
        case 1:
            updateBatchActive(value: false)
        case 2:
            updateBatchNumEaten()
        default:
            break
        }
    }
}

