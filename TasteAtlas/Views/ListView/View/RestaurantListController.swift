//
//  RestaurantListController.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/9.
//

import UIKit

final class RestaurantListController: UIViewController {
    
    private let interactor: RestaurantListInteractor
    
    init(interactor: RestaurantListInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
