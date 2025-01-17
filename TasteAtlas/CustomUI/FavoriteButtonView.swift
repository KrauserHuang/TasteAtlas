//
//  FavoriteButtonView.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2025/1/13.
//

import SwiftUI

struct FavoriteButtonView: View {
    
    @Binding var isFavorite: Bool
    var size: CGFloat = 16
    
    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.2)) {
                isFavorite.toggle()
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: size))
                .foregroundStyle(isFavorite ? .red : .black)
                .scaleEffect(isFavorite ? 1.1 : 1.0)
                .frame(width: size * 2, height: size * 2)
                .background {
                    Circle()
                        .fill(.white)
                        .shadow(color: .black.opacity(0.1),
                                radius: 4, x: 0, y: 0)
                }
        }
    }
}

#Preview {
    FavoriteButtonView(isFavorite: .constant(true))
    FavoriteButtonView(isFavorite: .constant(false))
}
