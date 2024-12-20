//
//  LoginViewController.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/19.
//

import Combine
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import UIKit
import FirebaseCore
import AuthenticationServices

class LoginViewController: UIViewController {
    
    private let signInWithApple = ASAuthorizationAppleIDButton()
    private let signInWithAppleButton = LoginButton(entry: .apple)
    private let signInWithFacebookButton = LoginButton(entry: .facebook)
    private let signInWithGoogleButton = LoginButton(entry: .google)
    private lazy var signInButtonVStackView = UIStackView(
        arrangedSubviews: [
            signInWithApple,
            signInWithAppleButton,
            signInWithFacebookButton,
            signInWithGoogleButton
        ],
        axis: .vertical,
        spacing: 10
    )
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(signInButtonVStackView)
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            signInButtonVStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            signInButtonVStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 2),
            signInButtonVStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding * 2),
            
            signInWithAppleButton.heightAnchor.constraint(equalToConstant: 50),
            signInWithFacebookButton.heightAnchor.constraint(equalTo: signInWithAppleButton.heightAnchor),
            signInWithGoogleButton.heightAnchor.constraint(equalTo: signInWithAppleButton.heightAnchor),
            signInWithApple.heightAnchor.constraint(equalTo: signInWithAppleButton.heightAnchor)
        ])
    }
    
    private func setupBindings() {
        signInWithGoogleButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
            }
            .store(in: &subscriptions)
    }
}
