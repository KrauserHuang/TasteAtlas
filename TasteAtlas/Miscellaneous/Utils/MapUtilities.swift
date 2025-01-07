//
//  MapUtilities.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2025/1/3.
//

import Foundation
import MapKit

func performSearch(query: String, visibleRegion: MKCoordinateRegion?) async throws -> [MKMapItem] {
    
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    
    guard let region = visibleRegion else { return [] }
    request.region = region
    
    let search = MKLocalSearch(request: request)
    let response = try await search.start()
    
    return response.mapItems
}
