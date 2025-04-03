//
//  BackgroundView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/26/25.
//

import SwiftUI

// Reusable background image view

struct BackgroundView: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}
