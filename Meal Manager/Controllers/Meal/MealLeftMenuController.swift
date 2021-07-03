//
//  MealLeftMenuController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-12.
//

import UIKit
import ViewAnimator

class MealLeftMenuController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let options = ["Reset Eaten"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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
            resetSelected(alert: alert)
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
    
    func resetSelected(alert: UIAlertController) {
        alert.addAction(UIAlertAction(title: options[0], style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            print("Reset pressed")
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
