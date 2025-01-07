//
//  MapSwiftUIView.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/26.
//

import MapKit
import SwiftUI

enum MapOptions: String, Identifiable, CaseIterable {
    case standard
    case hybrid
    case imagery
    
    var id: String { rawValue }
    
    var mapStyle: MapStyle {
        switch self {
        case .standard: return .standard
        case .hybrid: return .hybrid
        case .imagery: return .imagery
        }
    }
}

struct MapSwiftUIView: View {
    
    @State private var locationManager = LocationManager.shared
    @State private var selectedMapOption: MapOptions = .standard
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var mapItems: [MKMapItem] = []
    @State private var isSearching: Bool = false
    @State private var visibleRegion: MKCoordinateRegion?
    
    @Namespace var mapScope
    
    private func search() async {
        do {
            mapItems = try await performSearch(query: "Coffee", visibleRegion: visibleRegion)
            isSearching = false
        } catch {
            mapItems = []
            isSearching = false
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $position, scope: mapScope) {
                ForEach(mapItems, id: \.self) { mapItem in
                    Marker(item: mapItem)
                }
                UserAnnotation()
            }
            .mapControlVisibility(.hidden)
            .mapStyle(.standard(elevation: .realistic))
            .onChange(of: locationManager.region) {
                withAnimation {
                    position = .region(locationManager.region)
                }
            }
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
            .task(id: isSearching) {
                if isSearching {
                    await search()
                }
            }
            .overlay(alignment: .topTrailing) {
                VStack {
                    Spacer()
                    MapUserLocationButton(scope: mapScope)
                    MapPitchToggle(scope: mapScope)
                    MapCompass(scope: mapScope)
                        .mapControlVisibility(.visible)
                    Spacer()
                }
                .padding(.trailing, 10)
                .buttonBorderShape(.roundedRectangle)
            }
            .mapScope(mapScope)
        }
    }
}

#Preview {
    MapSwiftUIView()
}
