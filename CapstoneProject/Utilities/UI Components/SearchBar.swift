//
//  SearchBar.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/26/25.
//

import SwiftUI

// Filters menu items

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if searchText.isEmpty {
                Text("Search")
                    .foregroundColor(.white)
                    .padding(.leading, 40)
            }
            
            TextField("", text: $searchText)
                .padding()
                .foregroundColor(.white)
                .background(
                    LinearGradient(gradient: Gradient(colors: [
                        Color.black.opacity(0.3),
                        Color.white.opacity(0.1),
                        Color.black.opacity(0.3)
                    ]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 10)
        }
    }
}

