//
//  ViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-05.
//

import UIKit

class WelcomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func screenTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // create tab controller
        let mainTabBarController = storyboard.instantiateViewController(identifier: K.Views.tabBarCtr)
        
        // UIApplication.shared.connectedScenes.first gets first scene connected to the app
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        
    }
    
}

