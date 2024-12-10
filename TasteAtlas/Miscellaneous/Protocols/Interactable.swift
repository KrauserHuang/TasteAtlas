//
//  Interactable.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/10.
//

import Combine

/// A protocol that makes views interactable
protocol Interactable {
    /// The associated interaction type. Often an enum with interactions in a view
    associatedtype Interaction
    
    /// The interaction publisher that communicates the interactions
    var interaction: AnyPublisher<Interaction, Never> { get }
}
