//
//  UIViewController.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/25.
//

#if DEBUG
import SwiftUI

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
    
    func showPreview() -> some View {
        Preview(viewController: self)
    }
}

#endif
