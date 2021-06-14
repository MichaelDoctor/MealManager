//
//  MealLeftMenuController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-12.
//

import UIKit
import ViewAnimator

class MealLeftMenuController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}

//MARK: - Left Slide Animation

extension MealLeftMenuController {
    func animate() {
        let animation = AnimationType.vector(CGVector(dx: -self.view.frame.width / 2, dy: 0))
        
        UIView.animate(views: tableView.visibleCells, animations: [animation])
    }
}
