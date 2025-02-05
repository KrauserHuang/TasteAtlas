//
//  PlaceCardView.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2025/1/13.
//

import SwiftUI
import MapKit

struct PlaceCardView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var isFavorite: Bool = false
    @Binding var selectedItem: MKMapItem?
    
    // Helper function to determine if we have a custom image for this location
    private func getLocationImage() -> String? {
        // You can customize this logic based on your needs
        // For example, match by name, coordinates, or other criteria
        guard let name = selectedItem?.name?.lowercased() else { return nil }
        
        // Add mappings for locations that have custom images
        let imageMapping = [
            "moraine lake": "banff",
            // Add more mappings as needed
            // "location name": "image_name",
        ]
        
        return imageMapping[name]
    }
    
    private func printPlacemarkInfo() {
        guard let placemark = selectedItem?.placemark else { return }
        
        // Print all available placemark information
        print("=== Placemark Information ===")
        print("Name: \(placemark.name ?? "N/A")")
        print("Title: \(placemark.title ?? "N/A")")
        print("Thoroughfare (Street): \(placemark.thoroughfare ?? "N/A")")
        print("SubThoroughfare (Street Number): \(placemark.subThoroughfare ?? "N/A")")
        print("Locality (City): \(placemark.locality ?? "N/A")")
        print("SubLocality: \(placemark.subLocality ?? "N/A")")
        print("Administrative Area (State): \(placemark.administrativeArea ?? "N/A")")
        print("SubAdministrative Area: \(placemark.subAdministrativeArea ?? "N/A")")
        print("Postal Code: \(placemark.postalCode ?? "N/A")")
        print("Country: \(placemark.country ?? "N/A")")
        print("ISO Country Code: \(placemark.isoCountryCode ?? "N/A")")
        print("Location: \(placemark.location?.coordinate.latitude ?? 0), \(placemark.location?.coordinate.longitude ?? 0)")
        
        // Print MKMapItem specific information
        print("\n=== MapItem Information ===")
        print("Phone Number: \(selectedItem?.phoneNumber ?? "N/A")")
        print("URL: \(selectedItem?.url?.absoluteString ?? "N/A")")
        print("Point of Interest Category: \(selectedItem?.pointOfInterestCategory?.rawValue ?? "N/A")")
//        if let hours = selectedItem?.openingHours {
//            print("Opening Hours: \(hours)")
//        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
//                Image(.banff)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
                if let imageName = getLocationImage() {
                    // Use custom image if available
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    // Default placeholder based on location type
                    Group {
                        if let category = selectedItem?.pointOfInterestCategory {
                            switch category {
                            case .cafe:
                                Image(systemName: "cup.and.saucer.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(40)
                                    .foregroundStyle(.brown)
                            case .restaurant:
                                Image(systemName: "fork.knife")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(40)
                                    .foregroundStyle(.orange)
                                // Add more cases as needed
                            default:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(40)
                                    .foregroundStyle(.gray)
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(40)
                                .foregroundStyle(.gray)
                        }
                    }
                    .background(Color.secondary.opacity(0.1))
                }
                
                HStack {
                    FavoriteButtonView(isFavorite: $isFavorite)
                    DismissButtonView {
                        selectedItem = nil
                        dismiss()
                    }
                }
                .padding([.top, .trailing], 10)
            }
            
            VStack(alignment: .leading) {
                if let placemark = selectedItem?.placemark {
                    Text(placemark.name ?? "Unknown Location")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if let locality = placemark.locality {
                        Text(locality)
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    if let countryCode = placemark.isoCountryCode {
                        Text(countryCode.convertToFlag())
                    }
                }
//                Text("Moraine Lake")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                Text("Banff National Park")
//                    .foregroundStyle(.secondary)
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                Text("🇨🇦")
            }
            .padding(.leading)
        }
        .onAppear {
            printPlacemarkInfo()
        }
    }
}

#Preview {
    let coordinate = CLLocationCoordinate2D(latitude: 51.3262, longitude: -116.1855)
    let addressDictionary = ["name": "Moraine Lake",
                             "locality": "Banff National Park",
                             "ISO_country_code": "CA"]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
    let mapItem = MKMapItem(placemark: placemark)
    PlaceCardView(selectedItem: .constant(mapItem))
}
