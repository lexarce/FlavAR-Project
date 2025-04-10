//
//  DividerView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/26/25.
//

import SwiftUI

// Draws section dividers in menu

struct DividerView: View {
    var body: some View {
        Image("Line")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
    }
}
