//
//  CategoryItemView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/26/25.
//

import SwiftUI

// Displays category icons with text

struct CategoryItemView: View {
    let imageName: String
    let categoryName: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .cornerRadius(10)

            Text(categoryName)
                .font(.caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}
