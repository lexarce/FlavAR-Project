//
//  GradientBackgroundView.swift
//  CapstoneProject
//
//  Created by kimi on 4/9/25.
//


import SwiftUI

struct GradientBackgroundView: View {
    var startHex: String
    var endHex: String
    var startPoint: UnitPoint = .topLeading
    var endPoint: UnitPoint = .bottomTrailing

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: startHex), Color(hex: endHex)]),
            startPoint: startPoint,
            endPoint: endPoint
        )
        .edgesIgnoringSafeArea(.all)
    }
}
