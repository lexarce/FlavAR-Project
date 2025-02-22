//
//  CreateAccountView.swift
//  CapstoneProject
//
//  Created by Kaleb on 9/23/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CreateAccountView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var emailAddress = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    @State private var errorMessage = ""
    @State private var isAccountCreated = false
    @State private var toLoginPage = false

    var body: some View {
        ZStack {
            // Background Image
            Image("createaccountbg")
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            ScrollView { // Wrap the form in a ScrollView
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

                    ErrorMessageView(message: errorMessage)
                        .opacity(errorMessage.isEmpty ? 0 : 1)

                    Spacer()

                    Button(action: handleRegister) {
                        Text("REGISTER  >")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 30).fill(Color("AppColor4"))) 
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: LoginView(), isActive: $toLoginPage) {
                        EmptyView()
                    }
                    .hidden()

                    Text("Upon successful account creation, you will be redirected to the login page")
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                }
                .padding()
                .padding(.top, 150)
            }
        }
    }

    private func handleRegister() {
        guard checkInput() else { return }
        createAccount(emailAddress: emailAddress, password: password) { success in
            if success {
                isAccountCreated = true
                toLoginPage = true
            } else {
                errorMessage = "Unable to create account. Please try again."
            }
        }
    }
    
    private func checkInput() -> Bool {
        if firstName.isEmpty || lastName.isEmpty || emailAddress.isEmpty || phoneNumber.isEmpty || password.isEmpty || confirmedPassword.isEmpty {
            errorMessage = "Please fill out all fields"
            return false
        }
        if firstName.count > 50 {
            errorMessage = "First name cannot exceed 50 characters"
            return false
        }
        if lastName.count > 50 {
            errorMessage = "Last name cannot exceed 50 characters"
            return false
        }
        if phoneNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
            errorMessage = "Phone number must contain only digits"
            return false
        }
        if phoneNumber.count < 7 || phoneNumber.count > 15 {
            errorMessage = "Phone number must be between 7 and 15 digits"
            return false
        }
        if password.count < 8 || password.count > 30 {
            errorMessage = "Password must be between 8 and 30 characters"
            return false
        }
        if !isPasswordStrong(password) {
            errorMessage = "Password too weak. Include uppercase, lowercase, number, and special characters"
            return false
        }
        if password != confirmedPassword {
            errorMessage = "Passwords do not match"
            return false
        }
        return true
    }
    
    private func createAccount(emailAddress: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: emailAddress, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                completion(false)
                return
            }
            guard let user = authResult?.user else {
                completion(false)
                return
            }
            let db = Firestore.firestore()
            db.document("users/\(user.uid)").setData([
                "firstName": firstName,
                "lastName": lastName,
                "emailAddress": emailAddress,
                "phoneNumber": phoneNumber,
                "isAdmin": false
            ]) { error in
                if let error = error {
                    errorMessage = error.localizedDescription
                    completion(false)
                } else {
                    sendEmailVerification(user: user)
                    completion(true)
                }
            }
        }
    }
    
    private func sendEmailVerification(user: User) {
        user.sendEmailVerification { error in
            if let error = error {
                errorMessage = error.localizedDescription
            }
        }
    }
}

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

#Preview {
    CreateAccountView()
}
