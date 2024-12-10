//
//  MapViewModel.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/11.
//

import UIKit

extension MapView {
    final class ViewModel {
        @Published var state: State = .idle
        
        enum State {
            case idle, loading
        }
    }
}
