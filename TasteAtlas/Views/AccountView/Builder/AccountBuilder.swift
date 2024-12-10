//
//  AccountBuilder.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/10.
//

import UIKit

final class AccountBuilder {
    static func build() -> NavigationController {
        let router = AccountRouter()
        let interactor = AccountInteractor()
        let viewController = AccountController(interactor: interactor)
        let navigationController = NavigationController(rootViewController: viewController)
        navigationController.setNavbarApp(color: .systemRed)
        return navigationController
    }
}
