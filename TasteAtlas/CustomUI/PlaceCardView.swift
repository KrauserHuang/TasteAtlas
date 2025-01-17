//
//  PlaceCardView.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2025/1/13.
//

import SwiftUI

struct PlaceCardView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var isFavorite: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image(.banff)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                HStack {
                    FavoriteButtonView(isFavorite: $isFavorite)
                    DismissButtonView {
                        dismiss()
                    }
                }
                .padding([.top, .trailing], 10)
            }
            
            VStack(alignment: .leading) {
                Text("Moraine Lake")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Banff National Park")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("🇨🇦")
            }
            .padding(.leading)
        }
    }
}

#Preview {
    PlaceCardView()
}
