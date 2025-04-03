//
//  ErrorMessageView.swift
//  CapstoneProject
//
//  Created by kimi on 4/3/25.
//

import SwiftUI

// MARK: - Error Message View
struct ErrorMessageView: View {
    var message: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.8))
            Text(message)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding(.horizontal)
    }
}
