//
//  ReLoginViewController.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/23.
//

import UIKit
import SwiftUI

class ReLoginViewController: UIViewController {
    
    private let viewModel = AuthenticationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        let loginView = LoginView()
            .environmentObject(viewModel)
        
        let hostingController = UIHostingController(rootView: loginView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
//        hostingController.view.pinToSuperview()
        hostingController.didMove(toParent: self)
        
        // Setup constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
