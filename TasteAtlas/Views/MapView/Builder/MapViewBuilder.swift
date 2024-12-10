//
//  MapViewBuilder.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/9.
//

import UIKit

/// A builder object used for building the `MapView` with all its' dependencies
final class MapViewBuilder {
    /// Build a `MapViewController` wrapped in a `NavigationController`
    /// - Returns: A new navigation controller with the map view controller as its' root view controller
    static func build() -> NavigationController {
        let router = MapViewRouter()
        let interactor = MapViewInteractor()
        let viewController = MapViewController(interactor: interactor)
        let navigationController = NavigationController(rootViewController: viewController)
        navigationController.setNavbarApp(color: .systemRed)
        return navigationController
    }
}
