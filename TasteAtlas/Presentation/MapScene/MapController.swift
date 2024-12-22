//
//  MapController.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/14.
//

import Combine
import MapKit
import UIKit

final class MapController: UIViewController {
    
    // MARK: - Private properties
    private let searchBarButton = SearchBarButton()
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(useAutoLayout: true)
//        mapView.overrideUserInterfaceStyle = .dark
        mapView.showsUserLocation = true
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(searchBarButton)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        mapView.pinToSuperview()
        NSLayoutConstraint.activate([
            searchBarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            searchBarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 2),
            searchBarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding * 2),
            searchBarButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
