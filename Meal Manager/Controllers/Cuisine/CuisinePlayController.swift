//
//  CuisinePlayController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-17.
//

import UIKit
import CoreLocation

protocol CuisinePlayControllerDelegate: AnyObject {
    var activeCuisines: [Cuisine] { get }
    var navigationController: UINavigationController? { get }
    func updateCuisine(cuisine: Cuisine, newNum: Int)
}


class CuisinePlayController: UIViewController {
    
    let locationManager = FindLocationManager.shared
    
    var cuisine: Cuisine?
    var delegate: CuisineMainController!
    var message = ""
    
    @IBOutlet var cuisineName: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tryAgainButton: UIButton!
    @IBOutlet var eatButton: UIButton!
    @IBOutlet var findButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        locationManager.getLocation()
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
        locationManager.findBestNearMe(forVC: self, cuisine: cuisine)
    }
    
    //MARK: - Try Again button
    @IBAction func tryAgainButtonTapped(_ sender: UIButton) {
        cuisine = delegate.activeCuisines.randomElement()
        message = "Try eating \(cuisine!.name!) Cuisine"
        setLabels()
    }
    
    //MARK: - Eat button
    @IBAction func eatButtonTapped(_ sender: UIButton) {
        guard let cuisine = cuisine else { return }
        
        delegate.updateCuisine(cuisine: cuisine, newNum: Int(cuisine.numberOfTimesEaten) + 1)
        
        if let detailViewController =
            storyboard?.instantiateViewController(identifier: K.Views.cuisineRightDetail) as? CuisineDetailViewController {
            
            detailViewController.cuisine = cuisine
            delegate.navigationController?.pushViewController(detailViewController, animated: true)
        }
        dismiss(animated: true)
    }
    
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        locationManager.presentInfo(forVC: self)
    }
}

//MARK: - Configure and Helper Functions
extension CuisinePlayController {
    private func configure() {
        setLabels()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        tryAgainButton.roundedButton(bg: .white, tint: UIColor.init(named: K.Color.accent)!)
        eatButton.roundedButton(bg: UIColor.init(named: K.Color.accent)!, tint: UIColor.init(named: K.Color.white)!)
        
        if cuisine == nil {
            tryAgainButton.isHidden = true
            eatButton.isHidden = true
            findButton.isHidden = true
        }
    }
    
    
    func setLabels() {
        DispatchQueue.main.async {
            self.cuisineName.text = self.cuisine?.name ?? "No Cuisines Found"
            self.messageLabel.text = self.message
        }
    }
}
