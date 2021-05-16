//
//  CuisineDetailViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-16.
//

import UIKit

class CuisineDetailViewController: UIViewController {
    
    var cuisine: Cuisine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = cuisine?.name
        navigationController?.navigationBar.tintColor = UIColor(named: K.Color.white)
    }

}
