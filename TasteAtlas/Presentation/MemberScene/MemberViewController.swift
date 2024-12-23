//
//  MemberViewController.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/21.
//

import Combine
import FirebaseAuth
import UIKit

class MemberViewController: UIViewController {
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let viewModel = AuthenticationViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
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
        
        let rightBarButton = UIBarButtonItem(title: "設定", style: .plain, target: self, action: #selector(navigateUserProfile))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func navigateUserProfile() {
        if user != nil {
            let vc = UserProfileViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = LoginViewController()
            present(vc, animated: true)
        }
    }
}
