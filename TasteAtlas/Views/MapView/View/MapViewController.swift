//
//  MapViewController.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/9.
//

import Combine
import UIKit

protocol MapViewProtocol: AnyObject {
    var interaction: AnyPublisher<MapView.Interaction, Never> { get }
//    var viewModel: MapView.ViewModel { get }
}

final class MapViewController: ViewController<MapView> {
    
    private let interactor: MapViewInteractable
    
    init(viewModel: MapView.ViewModel, interactor: MapViewInteractable) {
        self.interactor = interactor
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
