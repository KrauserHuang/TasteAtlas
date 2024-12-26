//
//  MemberView.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/26.
//

import SwiftUI

struct MemberView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            Text(viewModel.user?.displayName ?? "Guest")
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
    }
}

#Preview("Light Mode") {
    MemberView()
        .preferredColorScheme(.light)
        .environmentObject(AuthenticationViewModel())
}

#Preview("Dark Mode") {
    MemberView()
        .preferredColorScheme(.dark)
        .environmentObject(AuthenticationViewModel())
}
