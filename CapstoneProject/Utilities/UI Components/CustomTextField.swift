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
    
    @State private var isPasswordVisible: Bool = false  // State for password visibility toggle

    var body: some View {
        HStack {
            if isSecureField {
                Group {
                    if isPasswordVisible {
                        TextField(placeholder, text: $text)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    } else {
                        SecureField(placeholder, text: $text)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                }
            } else {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            // Add the visibility toggle button
            if isSecureField {
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10) // Padding for the icon
            }
        }
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

struct CustomFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            .frame(height: 50)
    }
}
