//
//  CustomButton.swift
//  CapstoneProject
//
//  Created by kimi on 4/3/25.
//

import SwiftUI

struct CustomButton: View {
    let label: String
    let action: () -> Void
    var disabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .bold()
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(disabled ? Color.gray : Color("AppColor4"))
                )
        }
        .disabled(disabled)
        .padding(.horizontal, 20)
    }
}
