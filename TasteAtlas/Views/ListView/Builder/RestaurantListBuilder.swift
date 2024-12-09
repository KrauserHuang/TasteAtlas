//
//  RestaurantListBuilder.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/9.
//

import UIKit

final class RestaurantListBuilder {
    static func build() -> NavigationController {
        let router = RestaurantListRouter()
        let interactor = RestaurantListInteractor()
        let viewController = RestaurantListController(interactor: interactor)
        let navigationController = NavigationController(rootViewController: viewController)
        navigationController.setNavbarApp(color: .systemRed)
        return navigationController
    }
}
