//
//  MapViewBuilder.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/9.
//

import UIKit

/// A builder object used for building the `MapView` with all its' dependencies
enum MapViewBuilder {
    static func build() -> NavigationController {
        let router = MapViewRouter()
        let interactor = MapViewInteractor()
        let viewController = MapViewController(interactor: interactor)
        let navigationController = NavigationController(rootViewController: viewController)
        navigationController.setNavbarApp(color: .systemRed)
        return navigationController
    }
}
