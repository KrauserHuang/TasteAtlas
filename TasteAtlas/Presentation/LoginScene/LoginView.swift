//
//  LoginView.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/23.
//

import AuthenticationServices
import Combine
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
            
            Button(action: signInWithApple) {
                HStack {
                    Image(systemName: "apple.logo")
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding(.trailing, 8)
                    Text("Sign in with Apple")
                        .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .buttonStyle(.bordered)
            
            Button(action: signInWithFacebook) {
                HStack {
                    Image("facebooklogo")
                        .frame(width: 25, alignment: .center)
                        .padding(.trailing, 8)
                    Text("Sign in with Facebook")
                        .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .buttonStyle(.bordered)
            
            Button(action: signInWithGoogle) {
                HStack {
                    Image("googlelogo")
                        .frame(width: 25, alignment: .center)
                        .padding(.trailing, 8)
                    Text("Sign in with Google")
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
