//
//  LoginView.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/23.
//

import AuthenticationServices
import Combine
import FacebookLogin
import GoogleSignInSwift
import SwiftUI

enum FocusedField {
    case email, password
}

struct LoginView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @FocusState var focus: FocusedField?
    
    private func signInWithEmailPassword() {
        Task {
            if await viewModel.signInWithEmailPassword() == true {
                dismiss()
            }
        }
    }
    
    private func signInWithApple() {
        Task {
            if await viewModel.signInWithApple() == true {
                dismiss()
            }
        }
    }
    
    private func signInWithFacebook() {
        Task {
            if await viewModel.signInWithFacebook() == true {
                dismiss()
            }
        }
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
            // Header
            HStack {
                Text("Sign in to ")
                    .font(.system(size: 24, weight: .bold))
                Text("Jobsly")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.purple)
            }
            .frame(maxWidth: .infinity)
            // Subtitle
            Text("Welcome to Jobsly, please enter your login details\nbelow to using the app.")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .foregroundColor(.secondary)
                .padding()
            // Email
            TextField("Email", text: $viewModel.email)
                .padding()
                .frame(height: 56)
                .background()
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                }
                .focused($focus, equals: .email)
                .onSubmit {
                    focus = .password
                }
            // Password
            SecureField("Password", text: $viewModel.password)
                .padding()
                .frame(height: 56)
                .background()
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                }
                .focused($focus, equals: .password)
                .onSubmit {
                    signInWithEmailPassword()
                }
            
            if !viewModel.errorMessage.isEmpty {
              VStack {
                Text(viewModel.errorMessage)
                  .foregroundColor(Color(UIColor.systemRed))
              }
            }
            
            // Forgot password button
            Button {
                // Forgot password action
            } label: {
                Text("Forgot the password?")
                    .font(.system(size: 14))
//                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .fontWeight(.medium)
                    .foregroundColor(Color(uiColor: .link))
            }
//            .padding(.vertical, 10)
            
            // Login button
            Button(action: signInWithEmailPassword) {
                if viewModel.authenticationState != .authenticating {
                    Text("Login")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.vertical, 8)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                else {
                  ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                }
            }
            .disabled(!viewModel.isValid)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            // OR line
            HStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                Text("OR")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.vertical, 15)
            
            // Sign in with Google button
            Button(action: signInWithGoogle) {
                HStack {
                    Image("googlelogo")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 8)
                    
                    Text("Sign in with Google")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            // Sign in with Apple button
            Button(action: signInWithApple) {
                HStack {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.black)
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 8)
                    
                    Text("Sign in with Apple")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            // Sign in with Facebook button
            Button(action: signInWithFacebook) {
                HStack {
                    Image(.facebooklogo)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 8)
                    
                    Text("Sign in with Facebook")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                }
            }
            
            HStack {
                Text("Don't have an account?")
                    .fontDesign(.rounded)
                    .foregroundStyle(.secondary)
                
                Button {
                    // Forgot password action
                } label: {
                    Text("Sign up")
                        .font(.system(size: 14))
                        .frame(height: 30)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
        .listStyle(.plain)
        .padding()
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            LoginView()
//            LoginView()
//                .preferredColorScheme(.dark)
//        }
//        .environmentObject(AuthenticationViewModel())
//    }
//}

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
