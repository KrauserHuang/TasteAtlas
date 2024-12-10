//
//  MapView.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/10.
//

import Combine
import UIKit

final class MapView: UIView, ViewModable, Interactable {
    
    // MARK: - Private properties
    private let subject: PassthroughSubject<Interaction, Never> = .init()
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Public properties
    var interaction: AnyPublisher<Interaction, Never> { subject.eraseToAnyPublisher() }
    var viewModel: ViewModel! { didSet { setViewModel(viewModel) } }
    
    enum Interaction {
        case search(String)
    }
    
    func setViewModel(_ viewModel: ViewModel) {
        
    }
}
