//
//  MemberViewController.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/21.
//

import Combine
import FirebaseAuth
import UIKit
import SwiftUI

class MemberViewController: UIViewController {
    
    private let viewModel = AuthenticationViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupNavigation() {
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self else { return }
                self.user = user
                if let user {
                    title = user.displayName ?? "Unknown"
                } else {
                    title = "Username"
                }
            }
            .store(in: &subscriptions)
        let image = UIImage(systemName: "gear")?.withTintColor(.primaryEarth, renderingMode: .alwaysOriginal)
        let rightBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(navigateUserProfile))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func navigateUserProfile() {
        if user != nil {
            let vc = UserProfileViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
//            let vc = LoginViewController()
            let vc = ReLoginViewController()
            present(vc, animated: true)
        }
    }
    
    private func setupUI() {
        let memberView = MemberView()
            .environmentObject(viewModel)
        
        let hostingController = UIHostingController(rootView: memberView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
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
