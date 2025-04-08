//
//  AcctProfile.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/27/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AcctProfile: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userSessionViewModel: UserSessionViewModel
    @EnvironmentObject var navigationManager: NavigationManager

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var emailAddress = ""
    @State private var phoneNumber = ""

    // Password fields & visibility toggles
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""
    @State private var isCurrentPasswordSecure = true
    @State private var isNewPasswordSecure = true
    @State private var isConfirmPasswordSecure = true

    @FocusState private var focusedField: FocusedPasswordField?

    enum FocusedPasswordField: Hashable {
        case current
        case new
        case confirm
    }

    // Original data to detect changes
    @State private var originalFirstName = ""
    @State private var originalLastName = ""
    @State private var originalPhoneNumber = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    let userInfoManager = UserInfoManager()

    var isSaveDisabled: Bool {
        return (
            firstName == originalFirstName &&
            lastName == originalLastName &&
            phoneNumber == originalPhoneNumber &&
            currentPassword.isEmpty &&
            newPassword.isEmpty &&
            confirmNewPassword.isEmpty
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(imageName: "LightRedBG")

                VStack(spacing: 10) {
                    Spacer().frame(height: 80)

                    Text("Edit Profile")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)

                    Form {
                        Section(header: Text("Personal Info").foregroundColor(.white)) {
                            TextField("First Name", text: $firstName)
                            TextField("Last Name", text: $lastName)
                            TextField("Email", text: $emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                            TextField("Phone Number", text: $phoneNumber)
                        }

                        Section(header: Text("Change Password").foregroundColor(.white)) {
                            CustomTextField(
                                placeholder: "Current Password",
                                text: $currentPassword,
                                isSecureField: isCurrentPasswordSecure,
                                toggleVisibility: {
                                    isCurrentPasswordSecure.toggle()
                                    focusedField = nil
                                },
                                focus: $focusedField,
                                field: .current
                            )

                            CustomTextField(
                                placeholder: "New Password",
                                text: $newPassword,
                                isSecureField: isNewPasswordSecure,
                                toggleVisibility: {
                                    isNewPasswordSecure.toggle()
                                    focusedField = nil
                                },
                                focus: $focusedField,
                                field: .new
                            )

                            CustomTextField(
                                placeholder: "Confirm New Password",
                                text: $confirmNewPassword,
                                isSecureField: isConfirmPasswordSecure,
                                toggleVisibility: {
                                    isConfirmPasswordSecure.toggle()
                                    focusedField = nil
                                },
                                focus: $focusedField,
                                field: .confirm
                            )
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .cornerRadius(15)
                    .padding(.horizontal, 10)

                    // Save Changes Button
                    Button(action: {
                        updateProfile()
                    }) {
                        Text("SAVE CHANGES")
                            .bold()
                            .foregroundStyle(Color("AppColor1"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color("AppColor3"), .white, Color("AppColor3")]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    }
                    .padding(.horizontal, 60)

                    // Log Out Button
                    Button(action: {
                        logOut()
                    }) {
                        Text("LOG OUT")
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(30)
                            .padding(.horizontal, 60)
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 180)

                    Spacer()
                }

                // Bottom nav
                VStack {
                    Spacer()
                    NavigationBar()
                    Spacer().frame(height: 40)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrowshape.backward")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CustomerCartView()
                        .environmentObject(CartManager.shared)
                        .environmentObject(NavigationManager.shared)) {
                            Image(systemName: "cart")
                                .foregroundColor(.white)
                        }
                }
            }
            .onAppear {
                userInfoManager.fetchUserInfo { user in
                    if let user = user {
                        firstName = user.firstName
                        lastName = user.lastName
                        emailAddress = user.emailAddress
                        phoneNumber = user.phoneNumber

                        originalFirstName = user.firstName
                        originalLastName = user.lastName
                        originalPhoneNumber = user.phoneNumber
                    }
                }
            }
            .alert("Update", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    // MARK: - CustomTextField
    struct CustomTextField: View {
        var placeholder: String
        @Binding var text: String
        var isSecureField: Bool
        var toggleVisibility: () -> Void
        var focus: FocusState<FocusedPasswordField?>.Binding?
        var field: FocusedPasswordField?

        var body: some View {
            HStack {
                Group {
                    if isSecureField {
                        if let focus = focus, let field = field {
                            SecureField(placeholder, text: $text)
                                .focused(focus, equals: field)
                        } else {
                            SecureField(placeholder, text: $text)
                        }
                    } else {
                        if let focus = focus, let field = field {
                            TextField(placeholder, text: $text)
                                .focused(focus, equals: field)
                        } else {
                            TextField(placeholder, text: $text)
                        }
                    }
                }

                Button(action: {
                    toggleVisibility()
                }) {
                    Image(systemName: isSecureField ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Color.white)
            .cornerRadius(10)
        }
    }

    // MARK: - Update Profile
    private func updateProfile() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let updatedData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phoneNumber
        ]

        Firestore.firestore().collection("users").document(userID).updateData(updatedData) { error in
            if let error = error {
                alertMessage = "Profile update failed: \(error.localizedDescription)"
                showAlert = true
                return
            }

            // Handle password change if applicable
            if !currentPassword.isEmpty && !newPassword.isEmpty && newPassword == confirmNewPassword {
                let user = Auth.auth().currentUser
                let email = user?.email ?? emailAddress
                let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

                user?.reauthenticate(with: credential) { _, error in
                    if let error = error {
                        alertMessage = "Re-authentication failed: \(error.localizedDescription)"
                        showAlert = true
                    } else {
                        user?.updatePassword(to: newPassword) { error in
                            alertMessage = error == nil ? "Profile and password updated successfully!" :
                                "Password update failed: \(error!.localizedDescription)"
                            showAlert = true
                        }
                    }
                }
            } else if currentPassword.isEmpty && newPassword.isEmpty && confirmNewPassword.isEmpty {
                alertMessage = "Profile updated successfully!"
                showAlert = true
            } else {
                alertMessage = "Password fields are invalid or do not match."
                showAlert = true
            }
        }
    }

    // MARK: - Log Out
    private func logOut() {
        do {
            try Auth.auth().signOut()
            userSessionViewModel.isAuthenticated = false
        } catch let signOutError as NSError {
            alertMessage = "Error signing out: \(signOutError.localizedDescription)"
            showAlert = true
        }
    }
}

#Preview {
    AcctProfile()
        .environmentObject(UserSessionViewModel())
        .environmentObject(NavigationManager.shared)
}

