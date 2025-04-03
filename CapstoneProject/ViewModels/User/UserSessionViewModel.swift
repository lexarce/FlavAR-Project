//
//  UserSessionViewModel.swift
//  CapstoneProject
//
//  Created by kimi on 4/3/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserSessionViewModel: ObservableObject {
    @Published var userInfo: UserInfo?
    @Published var isAuthenticated: Bool = false
    @Published var isAdmin: Bool = false
    @Published var errorMessage: String = ""
    @Published var toLoginPage: Bool = false

    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    private let userManager = UserInfoManager()

    
    // CREATE ACCOUNT
    func createAccount(firstName: String, lastName: String, email: String, phone: String, password: String, confirmedPassword: String) {
        guard checkInput(firstName: firstName, lastName: lastName, email: email, phone: phone, password: password, confirmedPassword: confirmedPassword) else {
            return
        }

        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            guard let user = result?.user else {
                self.errorMessage = "User creation failed"
                return
            }

            db.collection("users").document(user.uid).setData([
                "firstName": firstName,
                "lastName": lastName,
                "emailAddress": email,
                "phoneNumber": phone,
                "isAdmin": false
            ]) { error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    self.sendEmailVerification(user: user)
                    self.toLoginPage = true
                }
            }
        }
    }

    // SEND VERIFICATION EMAIL
    func sendEmailVerification(user: User) {
        user.sendEmailVerification { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    // VALIDATE INPUT
    func checkInput(firstName: String, lastName: String, email: String, phone: String, password: String, confirmedPassword: String) -> Bool {
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmedPassword.isEmpty {
            errorMessage = "Please fill out all fields"
            return false
        }
        if firstName.count > 50 || lastName.count > 50 {
            errorMessage = "Name too long"
            return false
        }
        if phone.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
            errorMessage = "Phone must be digits only"
            return false
        }
        if phone.count < 7 || phone.count > 15 {
            errorMessage = "Phone number must be between 7 and 15 digits"
            return false
        }
        if password.count < 8 || password.count > 30 {
            errorMessage = "Password must be between 8 and 30 characters"
            return false
        }
        if !isPasswordStrong(password) {
            errorMessage = "Password too weak"
            return false
        }
        if password != confirmedPassword {
            errorMessage = "Passwords do not match"
            return false
        }
        return true
    }
    
    // HELPER: test strength of password
    func isPasswordStrong(_ password: String) -> Bool {
        let minLength = 8
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*]).{\(minLength),}$"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }

    
    // LOGIN
    func login(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.errorMessage = "Invalid Email Address or Password"
                print("Login failed: \(error.localizedDescription)")
                self.isAuthenticated = false
                return
            }

            self.checkIfEmailIsVerified()
        }
    }

    // VERIFY EMAIL
    func checkIfEmailIsVerified() {
        guard let user = auth.currentUser else { return }

        user.reload { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.errorMessage = "Error verifying email: \(error.localizedDescription)"
                self.isAuthenticated = false
                return
            }

            if user.isEmailVerified {
                self.isAuthenticated = true
                self.fetchUserInfo()
            } else {
                do {
                    try self.auth.signOut()
                    self.errorMessage = "Please verify your email before logging in."
                    self.isAuthenticated = false
                } catch {
                    self.errorMessage = "Error signing out: \(error.localizedDescription)"
                }
            }
        }
    }

    // FETCH USER PROFILE
    func fetchUserInfo() {
        userManager.fetchUserInfo { [weak self] user in
            DispatchQueue.main.async {
                self?.userInfo = user
            }
        }
    }

    // CHECK ADMIN STATUS
    func checkAdminStatus() {
        guard let userId = auth.currentUser?.uid else {
            print("No user is currently signed in.")
            return
        }

        db.collection("users").document(userId).getDocument { [weak self] document, error in
            guard let self = self else { return }

            if let error = error {
                print("Error checking admin: \(error.localizedDescription)")
                self.isAdmin = false
                return
            }

            if let document = document, document.exists {
                let isAdmin = document.data()?["isAdmin"] as? Bool ?? false
                DispatchQueue.main.async {
                    self.isAdmin = isAdmin
                }
            }
        }
    }

    // LOG OUT
    func logout() {
        do {
            try auth.signOut()
            isAuthenticated = false
            userInfo = nil
        } catch {
            errorMessage = "Error signing out"
        }
    }
}
