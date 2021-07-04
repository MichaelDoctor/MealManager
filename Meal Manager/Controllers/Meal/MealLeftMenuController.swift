//
//  MealLeftMenuController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-12.
//

import UIKit
import ViewAnimator
import CoreData

class MealLeftMenuController: UITableViewController {

    let options = ["Reset Recently Eaten", "Reset All Eaten Data"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

//MARK: - Core Data
extension MealLeftMenuController {
    //MARK: - Update
    func updateBatchRecentlyEaten(value didEat: Bool) {
        let request = NSBatchUpdateRequest(entityName: "Meal")
        request.predicate = NSPredicate(format: "didEat == %@", NSNumber(value: didEat))
        request.propertiesToUpdate = ["didEat": NSNumber(value: !didEat)]
        request.resultType = .updatedObjectIDsResultType
        
        do {
            let result = try K.context.execute(request) as! NSBatchUpdateResult
            
            let changes: [AnyHashable: Any] = [NSUpdatedObjectsKey: result.result as! [NSManagedObjectID]]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [K.context])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func updateBatchNumEaten() {
        let request = NSBatchUpdateRequest(entityName: "Meal")
        request.predicate = NSPredicate(format: "numberOfTimesEaten > %i", Int64(0))
        request.propertiesToUpdate = ["numberOfTimesEaten": Int64(0), "lastAte": Optional<Date>.none as Any]
        request.resultType = .updatedObjectIDsResultType
        
        do {
            let result = try K.context.execute(request) as! NSBatchUpdateResult

            let changes: [AnyHashable: Any] = [NSUpdatedObjectsKey: result.result as! [NSManagedObjectID]]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [K.context])
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - UITableViewDataSource
extension MealLeftMenuController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: K.Views.cuisineLeftCell)
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.textColor = UIColor(named: K.Color.red)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MealLeftMenuController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: options[indexPath.row], message: nil, preferredStyle: .alert)
        alert.redActions()
        
        switch indexPath.row {
        case 0:
            reenableEaten(alert: alert)
        case 1:
            resetAllEaten(alert: alert)
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

//MARK: - Configure Functions
extension MealLeftMenuController {
    private func configure() {
        tableView.removeExcessCells()
        navigationController?.isNavigationBarHidden = true
    }
    
    func reenableEaten(alert: UIAlertController) {
        alert.message = "Are you sure you want to re-enable all recently eaten meals?"
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.updateBatchRecentlyEaten(value: true)
            self.dismiss(animated: true)
        }))
    }
    
    func resetAllEaten(alert: UIAlertController) {
        alert.message = "Are you sure you want to reset all eaten data?"
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.updateBatchNumEaten()
            self.dismiss(animated: true)
        }))
    }
}

//MARK: - Left Slide Animation
extension MealLeftMenuController {
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
