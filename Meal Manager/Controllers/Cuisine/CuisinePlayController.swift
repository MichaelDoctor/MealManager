//
//  CuisinePlayController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-17.
//

import UIKit

class CuisinePlayController: UIViewController {
    
    var cuisine: Cuisine?
    var message = ""

    @IBOutlet var cuisineName: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cuisineName.text = cuisine?.name ?? "No Cuisines Found"
        messageLabel.text = message
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func nearMeButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func tryAgainButtonTapped(_ sender: UIButton) {
    }
    @IBAction func eatButtonTapped(_ sender: UIButton) {
    }
}
