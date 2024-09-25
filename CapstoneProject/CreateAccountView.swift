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
    @State var emailInput: String = ""
    @State var passwordInput: String = ""
    @State private var nicknameInput = ""  // Additional info test
    @State private var errorMessage = ""
    @State private var isAccountCreated = false
    
    var body: some View {
        VStack {
            Text("Email")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            //A normal text field
            TextField("Enter Email Address", text: $emailInput)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .stroke(Color.black, lineWidth: 2)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            
            Text("Password")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            //A text field that censors the text
            SecureField("Enter New Password", text: $passwordInput)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .stroke(Color.black, lineWidth: 2)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            
            Text("Nickname")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            //A text field that censors the text
            TextField("Enter Nickname", text: $nicknameInput)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .stroke(Color.black, lineWidth: 2)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            
            Button {
                //What happens when we hit the button goes here
                createAccount()
                
    
                
            } label: {//This is the physical button
                Text("Sign Up")
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue)
                    )
            }
            .padding(.leading, 100)
            .padding(.trailing, 100)
            
        }//End of VStack
        
        
    }
    
    func createAccount() {
            Auth.auth().createUser(withEmail: emailInput, password: passwordInput) { authResult, error in
                if let error = error {
                    // Handle error
                    errorMessage = error.localizedDescription
                } else if let authResult = authResult {
                    // Successfully created account, now store additional user info in Firestore
                    let db = Firestore.firestore()
                    db.collection("users").document(authResult.user.uid).setData([
                        "nickname": nicknameInput,
                        "email": emailInput,
                        "createdAt": FieldValue.serverTimestamp()
                    ]) { error in
                        if let error = error {
                            // Handle Firestore error
                            errorMessage = "Failed to store user info: \(error.localizedDescription)"
                        } else {
                            // Successfully stored user info
                            isAccountCreated = true
                            errorMessage = "Account successfully created!"
                        }
                    }
                }
            }
        }
}

#Preview {
    CreateAccountView()
}
