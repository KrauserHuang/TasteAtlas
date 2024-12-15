//
//  SearchBarButton.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/14.
//

import UIKit

final class SearchBarButton: UIButton {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Search"
        configuration.image = UIImage(systemName: "magnifyingglass")
        configuration.imagePadding = 5
        configuration.imagePlacement = .leading
        configuration.baseForegroundColor = .white
        configuration.background.backgroundColor = .black.withAlphaComponent(0.9)
        configuration.cornerStyle = .small
        
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 17)
            outgoing.foregroundColor = .lightGray
            return outgoing
        }
        
        self.configuration = configuration
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
