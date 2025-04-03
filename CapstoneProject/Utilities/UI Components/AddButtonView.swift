
//  AddButtonView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/26/25.
//

import SwiftUI

// Button for admins to add menu items

struct AddButtonView: View {
    var body: some View {
        NavigationLink(destination: CreateMenuItemView()) {
            HStack(spacing: 20) {
                Spacer()

                Button(action: {}) {
                    Image("PlusButton")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 10)
                        .padding(.top, 15)
                }
            }
            .padding(.horizontal)
        }
    }
}
