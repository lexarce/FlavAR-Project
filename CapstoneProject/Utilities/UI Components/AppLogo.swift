//
//  AppLogo.swift
//  CapstoneProject
//
//  Created by kimi on 4/3/25.
//


import SwiftUI

// MARK: - Reusable Subviews
struct AppLogo: View {
    var body: some View {
        Image("logo1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: 80)
            .padding(.bottom, 20)
    }
}
