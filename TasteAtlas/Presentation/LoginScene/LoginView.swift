//
//  LoginView.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/23.
//

import AuthenticationServices
import Combine
import FacebookLogin
import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    private func signInWithApple() {
        Task {
            if await viewModel.signInWithApple() == true {
                dismiss()
            }
        }
    }
    
    private func signInWithFacebook() {
//        Task {
//            if await viewModel.signInWithFacebook() == true {
//                dismiss()
//            }
//        }
    }
    
    private func signInWithGoogle() {
        Task {
            if await viewModel.signInWithGoogle() == true {
                dismiss()
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Sign in to your")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SignInWithAppleButton(.signIn) { request in
                viewModel.handleSignInWithAppleRequest(request)
            } onCompletion: { result in
                viewModel.handleSignInWithAppleCompletion(result)
            }
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .cornerRadius(8)
            
            FaceBookLoginButton(onLoginSuccess: { token in
                Task {
                    let success = await viewModel.signInWithFacebook(token: token.tokenString)
                    if success {
                        dismiss()
                    }
                }
            }, onLoginFailure: { error in
                print("Facebook login failed: \(error.localizedDescription)")
            }
            )
            .frame(maxWidth: .infinity, maxHeight: 50)
            .cornerRadius(8)
            
            Button(action: signInWithApple) {
                HStack {
                    Image(systemName: "apple.logo")
//                        .frame(width: 30, height: 30, alignment: .center)
                        .padding(.trailing, 0)
                    Text("Sign in with Apple")
                        .font(.headline)
                        .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .buttonStyle(.bordered)
            
            Button(action: signInWithFacebook) {
                HStack {
                    Image("facebooklogo")
//                        .frame(width: 20, alignment: .center)
                        .padding(.trailing, 8)
                    Text("Sign in with Facebook")
                        .font(.headline)
                        .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .buttonStyle(.bordered)
            
            Button(action: signInWithGoogle) {
                HStack {
                    Image("googlelogo")
//                        .frame(width: 25, alignment: .center)
                        .padding(.trailing, 0)
                    Text("Sign in with Google")
                        .font(.headline)
                        .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .buttonStyle(.bordered)
        }
        .listStyle(.plain)
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
            LoginView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(AuthenticationViewModel())
    }
}

struct FaceBookLoginButton: UIViewRepresentable {
    var onLoginSuccess: (AccessToken) -> Void
    var onLoginFailure: (Error) -> Void
    
    func makeUIView(context: Context) -> FBLoginButton {
        let button = FBLoginButton()
        button.delegate = context.coordinator
        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {
        //
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, LoginButtonDelegate {
        
        var parent: FaceBookLoginButton
        
        init(_ parent: FaceBookLoginButton) {
            self.parent = parent
        }
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: (any Error)?) {
            if let error = error {
                parent.onLoginFailure(error)
                return
            }
            
            guard let token = AccessToken.current else {
                parent.onLoginFailure(NSError(domain: "FacebookLogin", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get access token"]))
                return
            }
            
            parent.onLoginSuccess(token)
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            //
        }
    }
}
