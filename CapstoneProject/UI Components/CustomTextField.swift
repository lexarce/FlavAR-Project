//
//  CustomTextFIeld.swift
//  CapstoneProject
//
//  Created by Kaleb on 1/26/25.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var backgroundColor: Color = .white
    var height: CGFloat = 50
    var textColor: Color = .black // Default text color
    
    var isSecureField: Bool = false
    
    var body: some View {
        if isSecureField {
            SecureField(placeholder, text: $text)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(backgroundColor)
                        .stroke(Color.black, lineWidth: 2)
                        .frame(height: height)
                )
                .padding(.horizontal, 20)
                .autocorrectionDisabled(true)
                .foregroundColor(textColor)
        } else {
            TextField(placeholder, text: $text)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(backgroundColor)
                        .stroke(Color.black, lineWidth: 2)
                        .frame(height: height)
                )
                .padding(.horizontal, 20)
                .autocorrectionDisabled(true)
                .foregroundColor(textColor)
        }
    }
}

struct CustomFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            .frame(height: 50)
    }
}
