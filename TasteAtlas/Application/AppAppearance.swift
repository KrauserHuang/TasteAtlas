//
//  AppAppearance.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/26.
//

import UIKit

final class AppAppearance {
    
    static func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .darkGrey
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Set title text color
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Set large title text color
        
        let backImage = UIImage(systemName: "arrow.backward")
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().isTranslucent = false
    }
}
