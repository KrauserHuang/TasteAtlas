//
//  NavigationController.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/9.
//

import UIKit

final class NavigationController: UINavigationController, PresentableView {
    
    var transitionManager: UIViewControllerTransitioningDelegate?
    
    var receivingFrame: CGRect?
}

// MARK: -
extension NavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle { visibleViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle }
    override var childForStatusBarStyle: UIViewController? { visibleViewController }
}

// MARK: -
extension UINavigationController {
    /// Set the navigation bar appearance
    /// - Parameter color: color that set the navigation bar
    func setNavbarApp(color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.primaryEarth]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.primaryEarth]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().isTranslucent = false
    }
}
