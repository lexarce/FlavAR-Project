//
//  CreateAccountView.swift
//  CapstoneProject
//
//  Created by Kaleb on 9/23/24.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var emailAddress = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    
    var isRegisterDisabled: Bool {
        firstName.isEmpty ||
        lastName.isEmpty ||
        emailAddress.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        confirmedPassword.isEmpty ||
        password != confirmedPassword
    }

    @EnvironmentObject var userSessionViewModel: UserSessionViewModel
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Image
                Image("createaccountbg")
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack {
                        HeaderView() // Header with Sign Up Title

                        VStack(spacing: 16) {
                            HStack {
                                CustomTextField(placeholder: "First Name", text: $firstName)
                                CustomTextField(placeholder: "Last name", text: $lastName)
                            }
                            CustomTextField(placeholder: "Email address: email@gmail.com", text: $emailAddress)
                            CustomTextField(placeholder: "Phone Number", text: $phoneNumber)
                            CustomTextField(placeholder: "Password", text: $password, isSecureField: true)
                            CustomTextField(placeholder: "Confirm your Password", text: $confirmedPassword, isSecureField: true)
                        }
                        .padding()

                        ErrorMessageView(message: userSessionViewModel.createAccountErrorMessage)
                            .opacity(userSessionViewModel.createAccountErrorMessage.isEmpty ? 0 : 1)

                        Spacer()

                        Button(action: {
                            userSessionViewModel.createAccount(
                                firstName: firstName,
                                lastName: lastName,
                                email: emailAddress,
                                phone: phoneNumber,
                                password: password,
                                confirmedPassword: confirmedPassword
                            )
                        }) {
                            Text("Finish Creating Account >")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 30).fill(isRegisterDisabled ? Color.gray : Color("AppColor4")))
                                .foregroundColor(.white)
                        }
                        .disabled(isRegisterDisabled)
                        .padding(.horizontal)

                        // Text below button
                        Text("Upon successful account creation, a confirmation email will be sent to your email address you will be redirected to the login page")
                            .bold()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .padding()
                    .padding(.top, 150)
                }

                // Redirect to login page
                NavigationLink(
                    destination:
                        LoginView()
                        .environmentObject(navigationManager)
                        .environmentObject(userSessionViewModel),
                    isActive: $userSessionViewModel.toLoginPage
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
    }
}





#Preview {
    CreateAccountView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(UserSessionViewModel())
}
