//
//  MapViewController.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/9.
//

import Combine
import UIKit

final class MapViewController: UIViewController {
    
    private let interactor: MapViewInteractor
    
    init(interactor: MapViewInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
