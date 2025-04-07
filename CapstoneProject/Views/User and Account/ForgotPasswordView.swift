//
//  ForgotPasswordView.swift
//  CapstoneProject
//
//  Created by Kaleb on 4/6/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var isEmailSent = false
    @EnvironmentObject var userSessionViewModel: UserSessionViewModel
    
    var disabled: Bool {
            email.isEmpty
        }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Forgot Your Password?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("AppColor1"))
                .padding(.top, 30)
            
            Text("Enter your email address, and we'll send you a password reset link.")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("Email Address: example@gmail.com", text: $email)
                .keyboardType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)
            
            Button(action: {
                userSessionViewModel.forgotPassword(email: email)
                
                isEmailSent = true
            }) {
                Text("Send password reset email")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(disabled ? Color.gray : Color("AppColor4"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(email.isEmpty)
            
            // Neutral Confirmation Message
            if isEmailSent {
                Text("If this email is registered, a password reset link has been sent.")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20)
            .fill(Color.white)
            .shadow(radius: 10))
        .padding(.horizontal)
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(UserSessionViewModel())
}
