//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Nisa Aydin on 20.03.2024.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
        createTabBar()
     
    }
    
    func createTabBar(){
        let vcFirst = UINavigationController(rootViewController: HomeViewController())
        let vcSecond = UINavigationController(rootViewController: UpcomingViewController())
        let vcThird = UINavigationController(rootViewController: SearchViewController())
        let vcFourth = UINavigationController(rootViewController: DownloadsViewController())
        
        vcFirst.tabBarItem.image = UIImage(systemName: "house")
        vcSecond.tabBarItem.image = UIImage(systemName: "play.square")
        vcThird.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vcFourth.tabBarItem.image = UIImage(systemName: "square.and.arrow.down")
        
        vcFirst.title = "Home"
        vcSecond.title = "Coming Soon"
        vcThird.title = "Top Search"
        vcFourth.title = "Downloads"
        
        tabBar.tintColor = .label
        setViewControllers([vcFirst,vcSecond,vcThird,vcFourth], animated: true)
      
    }

}

