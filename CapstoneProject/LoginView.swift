//
//  LoginView.swift
//  CapstoneProject
//
//  Created by Kaleb on 9/23/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    
    //Variables
    //@State means that the variable changes are observed and updated in real time
    @State var emailInput: String = ""
    @State var passwordInput: String = ""
    @State private var errorMessage: String = ""
    @State private var loginSuccessful: Bool = false
    
    
    var body: some View {
        
        //Navigation stack allows for page changes using NavigationLink and NavigationDestination
        NavigationStack {
            //A VStack vertically stacks the objects within it like Text and TextField
            VStack {
                
                //A text object
                Text("Email")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                
                //A normal text field
                TextField("Enter Email", text: $emailInput)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .stroke(Color.black, lineWidth: 2)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .autocorrectionDisabled(true)
                
                //A Text object
                Text("Password")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                
                //A text (secure) field that censors the text
                SecureField("Enter Password", text: $passwordInput)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .stroke(Color.black, lineWidth: 2)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    //All these extra attributes keep the auto strong password suggestion from appearing
                    .autocorrectionDisabled(true)
                    .textContentType(.none)
                    .keyboardType(.default)
                    .autocapitalization(.none)
                
                
                Button {
                    //Where the functionality for the pressing of "Forgot Password" will go
                    
                } label: {//The "label" is the physical button that can be pressed
                    //The label is the text itself
                    Text("Forgot Password")
                        .bold()
                        .foregroundStyle(.blue)
                        .padding()
                }
                .offset(y: -15)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                //Sign In Button
                Button {
                    //This is what will happen when we press "Sign In"
                    //Calls loginUser
                    loginUser(email: emailInput, password: passwordInput)
                    
                } label: {//This is the physical button
                    Text("Sign In")
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
                
                Text(errorMessage)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                //A button to take the user to CreateAccountView
                Button {
                    
                } label: {//This is the physical button
                    //It will take us to CreateAccountView
                    NavigationLink(destination: CreateAccountView()) {
                        Text("Don't have an account? Create one here")
                            .bold()
                            .foregroundStyle(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
                .offset(y: 200)
                
                // NavigationLink to HomePageView
                NavigationLink(destination: HomePageView(), isActive: $loginSuccessful) {
                    EmptyView()
                }
                .hidden() // Hides the EmptyView

            }//End of the VStack

        }//End of Navigation Stack

    }//End of body
        
    //Authenticates the user with their entered email address and password
    func loginUser(email: String, password: String) {
            //This is a firebase function call, we pass it the email and password
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                // Check if there's an error during the login process
                if let error = error {
                    // unsuccessful login
                    errorMessage = error.localizedDescription
                    print("Simulating unsuccessful login")
                    errorMessage = "Invalid Email Address or Password"
                    
                    // Simulate that user is not logged in
                    loginSuccessful = false
                } else {
                    // successful login
                    print("Simulating successful login")
                    
                    loginSuccessful = true //We use this boolean to prove that the user was authenticatteed
                    
                }
            }
        }
    
}

//We can preset values for variables in #Preview to see their effects on the UI preview
#Preview {
    LoginView()
}
