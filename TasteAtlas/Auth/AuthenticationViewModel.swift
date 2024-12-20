//
//  AuthenticationViewModel.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/20.
//

import Foundation
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
