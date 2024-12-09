//
//  ReuseIdentifiable.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/8.
//

import Foundation

/// A protocol that makes its subscribers identifiable
protocol ReuseIdentifiable {
    /// A static string that represents the reuse identifier
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
