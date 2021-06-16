//
//  ViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-05.
//

import UIKit

class WelcomeController: UIViewController {

    @IBOutlet var getStartedButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

//MARK: - Configurations
extension WelcomeController {
    private func configure() {
        getStartedButton.roundedButton(bg: UIColor(named: K.Color.accent)!, tint: .white)
    }
}

//MARK: - Buttons
extension WelcomeController {
    
    @IBAction func getStartedTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: K.Views.tabBarCtr)

        // UIApplication.shared.connectedScenes.first gets first scene connected to the app. Change scene
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
}
