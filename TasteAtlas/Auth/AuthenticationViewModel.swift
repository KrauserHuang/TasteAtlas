//
//  AuthenticationViewModel.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/20.
//

import AuthenticationServices
import CryptoKit
import Foundation
import FacebookCore
import FacebookLogin
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

//struct AuthenticationViewModelEnvironmentKey: EnvironmentKey {
//    static let defaultValue: AuthenticationViewModel = AuthenticationViewModel()
//}
//
//extension EnvironmentValues {
//    var authenticationVM: AuthenticationViewModel {
//        get { self[AuthenticationViewModelEnvironmentKey.self] }
//        set { self[AuthenticationViewModelEnvironmentKey.self] = newValue }
//    }
//}

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
    @Published var user: User?
    @Published var errorMessage: String = ""
    @Published var displayName: String = ""
    
    /*
     user.uid → a way to keep track of any document that belong to the user in Cloud FireStore...etc
     */
    
    private var currentNonce: String?
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
    // 儲存Firebase Authentication State參數
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    // 註冊Firebase Authentication State(Listener)，在AuthenticationViewModel init時呼叫
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            // 當user sign in，user會有值，反之(sign out)則變成nil
            // 透過user的狀態來改變authenticationState
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? "(unknown)"
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

// MARK: - Sign in with Email and Password
extension AuthenticationViewModel {
    // 使用Email/Password進行登入
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            user = authResult.user
            print("User \(authResult.user.uid) signed in")
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            return false
        }
    }
    // 使用Email/Password進行註冊
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            user = authResult.user
            print("User \(authResult.user.uid) signed in")
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            return false
        }
    }
    // 登出
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    // 刪除帳號
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
    func signInWithFacebook(token: String) async -> Bool {
        authenticationState = .authenticating
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            return false
        }
        
        let manager = LoginManager()
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
        do {
            let result = try await Auth.auth().signIn(with: credential)
            self.user = result.user
            self.authenticationState = .authenticated
            self.displayName = result.user.displayName ?? ""
            return true
        } catch {
            print("Firebase sign-in failed: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.authenticationState = .unauthenticated
            return false
        }
    }
    
    func signInWithFacebook() async -> Bool {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            return false
        }
        
        let manager = LoginManager()
        
        // First continuation for Facebook Login
        let token: AccessToken? = await withCheckedContinuation { continuation in
            manager.logIn(permissions: [], from: rootViewController) { result, error in
                if let error = error {
                    print("Facebook login failed: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    continuation.resume(returning: nil)
                    return
                }
                
                guard let token = AccessToken.current else {
                    print("Facebook login failed: No token")
                    continuation.resume(returning: nil)
                    return
                }
                
                continuation.resume(returning: token)
            }
        }
        
        // Check if we got a token
        guard let validToken = token else {
            return false
        }
        
        // Now we can use async/await for Firebase auth
        let credential = FacebookAuthProvider.credential(withAccessToken: validToken.tokenString)
        
        do {
            let result = try await Auth.auth().signIn(with: credential)
            self.user = result.user
            self.displayName = result.user.displayName ?? ""
            return true
        } catch {
            print("Firebase sign-in failed: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            return false
        }
    }
}

// MARK: - Apple Sign In
extension AuthenticationViewModel {
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        // request裡的nonce是SHA256加密過的
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        } else if case .success(let success) = result {
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token.")
                    return
                }
                // idTokenString is a JWT format
                // 透過JWT.io decode之後可以看到裡面有email, sub, iss, aud, exp, iat, nonce(這也就是request時所帶入的加密過的nonce)等資訊
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                // Create Auth credential with providerID(apple)/idToken(appleIDToken)/rawNonce(nonce from the request method without SHA256)
                // Firebase will extract a nonce from the idToken and compare it with the rawNonce
                // Firebase會透過取出idToken內的nonce參數，並使用rawNonce在進行SHA256後進行比對
                let credential = OAuthProvider.credential(providerID: .apple,
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                
                Task {
                    do {
                        let result = try await Auth.auth().signIn(with: credential)
                        await updateDisplayName(for: result.user, with: appleIDCredential)
                    } catch {
                        print("Error signing in with Apple: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    // Firebase的displayName不是完整的fullname
    // Apple想要開發者知道username是很敏感的資訊，所以不會直接提供
    // 這邊需要透過Apple提供的fullName(givenName + familyName)來更新Firebase的displayName
    // 透過createProfileChangeRequest來更新firebase的displayName
    func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
        if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
            // current user is non-empty, don't overwrite it
        } else {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = appleIDCredential.displayName()
            do {
                try await changeRequest.commitChanges()
                self.displayName = Auth.auth().currentUser?.displayName ?? ""
            } catch {
                print("Unable to update the user's displayname: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
    }
    // TODO: - 預留，之後刪除
    func signInWithApple() async -> Bool {
        return false
    }
}

// 取得AppleIDCredential的fullName(givenName + familyName)
extension ASAuthorizationAppleIDCredential {
    func displayName() -> String {
        return [self.fullName?.givenName, self.fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    return result
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    return hashString
}
