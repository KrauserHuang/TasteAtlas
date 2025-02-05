//
//  DismissButtonView.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2025/1/13.
//

import SwiftUI

struct DismissButtonView: View {
    
    var size: CGFloat = 16
    var onDismiss: () -> Void
    
    var body: some View {
        Button {
            onDismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: size))
                .foregroundColor(.black)
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
    DismissButtonView {
        print("Dismiss")
    }
}
