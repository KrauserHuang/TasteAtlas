//
//  SearchBarView.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2025/1/7.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search for more...", text: $searchText)
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled(true)
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(searchText.isEmpty ? .clear : .secondary)
                        .onTapGesture {
                            searchText = ""
                        }
                }
                .onSubmit {
                    isSearching = true
                }
        }
        .font(.headline)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.background)
                .shadow(
                    color: .secondary.opacity(0.2),
                    radius: 10, x: 0, y: 0
                )
        }
        .padding()
    }
}

#Preview("SearchBarView", traits: .sizeThatFitsLayout) {
    SearchBarView(searchText: .constant("1"), isSearching: .constant(true))
}
