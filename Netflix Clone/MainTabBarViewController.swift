//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Yash Patil on 25/07/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())


        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")

        vc1.title = "Home"
        vc2.title = "Coming soon"
        vc3.title = "Search"
        vc4.title = "Downloads"

        self.tabBar.tintColor = .label
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)

        // Do any additional setup after loading the view.
    }
}

