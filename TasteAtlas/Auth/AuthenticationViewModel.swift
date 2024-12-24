//
//  AuthenticationViewModel.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/20.
//

import Foundation
import FacebookCore
import FacebookLogin
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var flow: AuthenticationFlow = .login
    
    @Published var isValid: Bool = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage: String = ""
    @Published var user: User?
    @Published var displayName: String = ""
    
    private let readPermissions: [String] = ["public_profile", "email"]
    
    init() {
        registerAuthStateHandler()
        
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
              flow == .login
              ? !(email.isEmpty || password.isEmpty)
              : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ""
            }
        }
    }
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Done")
        } catch { }
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
}

extension AuthenticationViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            return false
        }
    }
}

enum AuthenticationError: Error {
    case tokenError(message: String)
}

// MARK: - Google Sign In
extension AuthenticationViewModel {
    func signInWithGoogle() async -> Bool {
        /// 可以直接從 FirebaseApp.app()?.options.clientID 取得 clientID(App init時就會設定)
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        /// 設定 Google 登入配置
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            return false
        }
        
        do {
            /// 進入 Google 登入流程
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            /// 取得 ID token 和 Access token
            let user = userAuthentication.user
            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
            let accessToken = user.accessToken
            
            /// 用 ID token 和 Access token 建立 Firebase 憑證 ( provider 為 Google )
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            /// 使用憑證進行 Firebase 登入
            let result = try await Auth.auth().signIn(with: credential)
            
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print("ID Token \(idToken ?? "")")
            }
            
            /// 取得 Firebase 使用者
            let firebaseUser = result.user
            print("username \(firebaseUser.displayName ?? "Unknown")")
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "Unknown")")
            return true
        } catch {
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
            return false
        }
    }
}

// MARK: - Facebook Sign In
extension AuthenticationViewModel {
    func signInWithFacebook() async -> Bool {
        authenticationState = .authenticating
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            return false
        }
        
        let manager = LoginManager()
        return false
//        manager.logIn(permissions: readPermissions, from: rootViewController) { loginResult, error in
//            switch loginResult {
//            case .success:
//                break
//            case .failed(_):
//                break
//            }
//        }
//        let result = await withCheckedContinuation { continuation in
//            manager.logIn(permissions: ["public_profile", "email"], from: rootViewController) { loginResult, error in
//
//        }
    }
}

extension AuthenticationViewModel {
    func signInWithApple() async -> Bool {
        return false
    }
}
