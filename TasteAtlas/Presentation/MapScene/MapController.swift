//
//  MapController.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/14.
//

import Combine
import MapKit
import UIKit
import SwiftUI

final class MapController: UIViewController {
    
    // MARK: - Private properties
    private let searchBarButton = SearchBarButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
//        setupConstraints()
    }
    
//    private func setupUI() {
//        view.addSubview(mapView)
//        view.addSubview(searchBarButton)
//    }
//    
//    private func setupConstraints() {
//        let padding: CGFloat = 10
//        mapView.pinToSuperview()
//        NSLayoutConstraint.activate([
//            searchBarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
//            searchBarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 2),
//            searchBarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding * 2),
//            searchBarButton.heightAnchor.constraint(equalToConstant: 40),
//        ])
//    }
    
    private func setupUI() {
        let mapView = MapSwiftUIView()
        
        let hostingController = UIHostingController(rootView: mapView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
