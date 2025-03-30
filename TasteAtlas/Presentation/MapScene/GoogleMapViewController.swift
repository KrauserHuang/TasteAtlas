//
//  GoogleMapViewController.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2025/2/16.
//

import GoogleMaps
import UIKit

class GoogleMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGSMap()
    }
    
    private func setupGSMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 25.0330, longitude: 121.5654, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
//        let mapView = GMSMapView.init()
        view.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654)
        marker.title = "Taipei"
        marker.snippet = "Taiwan"
        marker.map = mapView
    }
}
