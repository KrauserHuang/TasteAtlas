//
//  LoginButton.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/20.
//

import UIKit

class LoginButton: UIButton {
    
    enum Entry {
        case apple
        case facebook
        case google
        
        var title: String {
            switch self {
            case .apple:
                return "Sign in with Apple"
            case .facebook:
                return "Sign in with Facebook"
            case .google:
                return "Sign in with Google"
            }
        }
        
        var image: UIImage {
            switch self {
            case .apple:
                return UIImage(systemName: "applelogo")!
            case .facebook:
                return UIImage(named: "facebooklogo") ?? UIImage(systemName: "applelogo")!
            case .google:
                return UIImage(named: "googlelogo") ?? UIImage(systemName: "applelogo")!
            }
        }
    }
    
    private let entry: Entry
    
    init(entry: Entry) {
        self.entry = entry
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        var configuration = UIButton.Configuration.filled()
        configuration.title = entry.title
        configuration.image = entry.image.scalePreservingAspectRatio(targetSize: CGSize(width: 25, height: 25))
        configuration.imagePadding = 10
        configuration.imagePlacement = .leading
        configuration.baseForegroundColor = .label
        configuration.background.backgroundColor = .signInButtonGray
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            return outgoing
        }
        self.configuration = configuration
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
