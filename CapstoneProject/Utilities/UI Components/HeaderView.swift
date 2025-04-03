//
//  HeaderView.swift
//  CapstoneProject
//
//  Created by kimi on 4/3/25.
//

import SwiftUI

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.bottom, 16)
    }
}
