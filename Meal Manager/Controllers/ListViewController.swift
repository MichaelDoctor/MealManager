//
//  ListViewController.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-06.
//

import UIKit
import GoogleMobileAds

class ListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        // replace later
        //        banner.adUnitID = "ca-app-pub-2009699556932262/
        // added to plist
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.load(GADRequest())
        //      banner.backgroundColor = .secondarySystemBackground
        banner.backgroundColor = .white
        return banner
    }()
    
    var test = ["Hello"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        banner.rootViewController = self
        view.addSubview(banner)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottom = view.window!.frame.size.height
        let tabBarHeight = tabBarController!.tabBar.frame.size.height
        banner.frame = CGRect(x: 0, y: bottom-tabBarHeight-50, width: view.frame.size.width, height: 50).integral
    }
    
}

//MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Views.cellIdentifier, for: indexPath)
        cell.textLabel?.text = test[indexPath.row]
        return cell
    }
}
