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
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $position) {
                Annotation("Taipei101", coordinate: .taiepi101) {
                    Image(systemName: "fireworks")
                        .padding(4)
                        .foregroundColor(.white)
                        .background(.red)
                        .cornerRadius(.infinity)
                }
                Annotation("Restaurant", coordinate: .restaurant) {
                    Image(systemName: "flame")
                        .padding(5)
                        .foregroundStyle(.blue)
                        .background(.yellow)
                        .cornerRadius(.infinity)
                }
                UserAnnotation()
            }
            .mapStyle(selectedMapOption.mapStyle)
            .onChange(of: locationManager.region) {
                withAnimation {
                    position = .region(locationManager.region)
                }
            }
            
            Picker("Map Styles", selection: $selectedMapOption) {
                ForEach(MapOptions.allCases) { mapOption in
                    Text(mapOption.rawValue.capitalized).tag(mapOption)
                }
            }
            .pickerStyle(.segmented)
            .background(.white)
            .padding()
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            position = .userLocation(fallback: .automatic)
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .padding(16)
                            .background(.black)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    MapSwiftUIView()
}
