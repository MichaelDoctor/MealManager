//
//  CuisinePlayController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-17.
//

import UIKit
import CoreLocation

class CuisinePlayController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = FindLocationManager.shared
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
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
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    //MARK: - Near Me button
    @IBAction func nearMeButtonTapped(_ sender: UIButton) {
        guard let lat = locationManager.lat,
              let long = locationManager.long else {
            print("Locations needed")
            return
        }
        guard let url = URL(string: "https://www.google.com/maps/search/\(cuisine?.name?.folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: " ", with: "+") ?? "")+restaurant+%40\(lat)%2C\(long)/@\(lat),\(long),11z/data=!4m4!2m3!5m1!4e3!6e5") else {
            print("URL broke")
            return
        }
        
        presentSafariVC(with: url)
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
