//
//  CuisinePlayController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-17.
//

import UIKit

class CuisinePlayController: UIViewController {
    
    var cuisine: Cuisine?
    var parentController: CuisineMainController?
    var message = ""
    
    @IBOutlet var cuisineName: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tryAgainButton: UIButton!
    @IBOutlet var eatButton: UIButton!
    @IBOutlet var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        K.roundedButton(tryAgainButton, bg: UIColor.init(named: K.Color.red)!, tint: UIColor.init(named: K.Color.white)!)
        K.roundedButton(eatButton, bg: UIColor.systemGreen, tint: UIColor.init(named: K.Color.black)!)
        if cuisine == nil {
            tryAgainButton.isHidden = true
            eatButton.isHidden = true
            findButton.isHidden = true
        }
    }
}

//MARK: - Buttons

extension CuisinePlayController {
    //MARK: - Cancel button
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - Near Me button
    @IBAction func nearMeButtonTapped(_ sender: UIButton) {
        print("Get Location and Google Search for now")
    }
    
    //MARK: - Try Again button
    @IBAction func tryAgainButtonTapped(_ sender: UIButton) {
        cuisine = parentController?.activeCuisines.randomElement()
        message = "Try eating \(cuisine!.name!) Cuisine"
        setLabels()
    }
    
    //MARK: - Eat button
    @IBAction func eatButtonTapped(_ sender: UIButton) {
        guard let cuisine = cuisine else { return }
        parentController?.updateCuisine(cuisine: cuisine, newNum: Int(cuisine.numberOfTimesEaten) + 1)
        if let detailViewController =
            storyboard?.instantiateViewController(identifier: K.Views.cuisineRightDetail) as? CuisineDetailViewController {
            
            detailViewController.cuisine = cuisine
            parentController?.navigationController?.pushViewController(detailViewController, animated: true)
        }
        dismiss(animated: true)
    }
}

//MARK: - Helper Functions
extension CuisinePlayController {
    func setLabels() {
        DispatchQueue.main.async {
            self.cuisineName.text = self.cuisine?.name ?? "No Cuisines Found"
            self.messageLabel.text = self.message
        }
    }
}
