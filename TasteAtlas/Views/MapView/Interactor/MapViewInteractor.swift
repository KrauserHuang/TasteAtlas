//
//  MapViewInteractor.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/9.
//

import Combine
import UIKit

protocol MapViewInteractable {
    
}

final class MapViewInteractor: MapViewInteractable {
    
    private var subscriptions: Set<AnyCancellable> = []
}
