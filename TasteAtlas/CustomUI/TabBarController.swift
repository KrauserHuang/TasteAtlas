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
        let mapView = MapViewBuilder.build()
        mapView.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
        
        setViewControllers([mapView], animated: false)
    }
}
