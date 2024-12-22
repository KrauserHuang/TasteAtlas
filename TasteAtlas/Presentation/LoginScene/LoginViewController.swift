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
    private let viewModel = AuthenticationViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        setupBindings()
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
                guard let self else { return }
                
                Task {
                    // 開始登入前禁用按鈕
                    await MainActor.run {
                        self.signInWithGoogleButton.isEnabled = false
                    }
                    
                    // 執行登入
                    let success = await self.viewModel.signInWithGoogle()
                    
                    // UI 更新需要在主線程
                    await MainActor.run {
                        if success {
                            // 登入成功的處理
                            print("Successfully signed in with Google")
                            // 這裡可以加入導航邏輯或其他 UI 更新
                            self.dismiss(animated: true)
                        } else {
                            // 登入失敗的處理
                            print("Failed to sign in with Google: \(self.viewModel.errorMessage)")
                            // 這裡可以顯示錯誤訊息給使用者
                        }
                        
                        // 重新啟用按鈕
                        self.signInWithGoogleButton.isEnabled = true
                    }
                }
            }
            .store(in: &subscriptions)
    }
}
