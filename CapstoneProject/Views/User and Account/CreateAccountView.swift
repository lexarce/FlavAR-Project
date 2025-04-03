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
                                CustomTextField(placeholder: "Last Name", text: $lastName)
                            }
                            CustomTextField(placeholder: "Email Address", text: $emailAddress)
                            CustomTextField(placeholder: "Phone Number", text: $phoneNumber)
                            CustomTextField(placeholder: "Password", text: $password, isSecureField: true)
                            CustomTextField(placeholder: "Confirm Password", text: $confirmedPassword, isSecureField: true)
                        }
                        .padding()

                        ErrorMessageView(message: userSessionViewModel.errorMessage)
                            .opacity(userSessionViewModel.errorMessage.isEmpty ? 0 : 1)

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
                            Text("REGISTER  >")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 30).fill(Color("AppColor4")))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)

                        // Text below button
                        Text("Upon successful account creation, you will be redirected to the login page")
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
