//
//  TabBarController.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/9.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
    
    private func setupTabbar() {
//        let mapView = MapViewBuilder.build()
//        mapView.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
        let mapView = MapController()
        mapView.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
        
        let restaurantListView = RestaurantListBuilder.build()
        restaurantListView.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        let accountView = AccountBuilder.build()
        accountView.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.crop.circle"), tag: 2)
        
        setViewControllers([mapView, restaurantListView, accountView], animated: false)
    }
}
