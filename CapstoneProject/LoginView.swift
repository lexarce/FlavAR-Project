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
                
                Image("logo1") // Refers to the image called "logo1" in your Assets folder
                    .resizable() // Makes the image resizable
                    .aspectRatio(contentMode: .fit) // Preserves the aspect ratio and fits the image
                    .frame(width: 80, height: 80)
                    .offset(y: -40)
                
                Text("LOGIN")
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .offset(y: -70)
                
                //A normal text field
                TextField("Email Address", text: $emailInput)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
                            .stroke(Color.black, lineWidth: 2)
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .autocorrectionDisabled(true)
                    .offset(y: -80)
                
                
                //A text (secure) field that censors the text
                SecureField("Password", text: $passwordInput)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
                            .stroke(Color.black, lineWidth: 2)
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    //All these extra attributes keep the auto strong password suggestion from appearing
                    .autocorrectionDisabled(true)
                    .textContentType(.newPassword)
                    .keyboardType(.default)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .offset(y: -70)
                
                
                
                //Sign In Button
                Button {
                    //This is what will happen when we press "Sign In"
                    //Calls loginUser
                    loginUser(email: emailInput, password: passwordInput)
                    
                } label: {//This is the physical button
                    Text("CONTINUE  >")
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color("AppColor4"))
                        )
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .offset(y: -50)
                
                Button {
                    //Where the functionality for the pressing of "Forgot Password" will go
                    
                } label: {//The "label" is the physical button that can be pressed
                    //The label is the text itself
                    Text("Forgot Password?")
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                        .underline()
                        .padding(.leading, 20)
                }
                .offset(y: -50)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(errorMessage)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.white)
                    .offset(y: -50)
                
                
                
                //A button to take the user to CreateAccountView
                Button {
                    
                } label: {//This is the physical button
                    //It will take us to CreateAccountView
                    NavigationLink(destination: CreateAccountView()) {
                        Text("CREATE AN ACCOUNT  >")
                            .bold()
                            .foregroundStyle(Color("AppColor1"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
//                                RoundedRectangle(cornerRadius: 30)
//                                    .fill(Color.white)
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color("AppColor3"), Color.white, Color("AppColor3")]), startPoint: .leading, endPoint: .trailing) // Center color is blue
                                    )
                            )
                    }
                }
                .offset(y: -30)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                // NavigationLink to HomePageView
                NavigationLink(destination: HomePageView(), isActive: $loginSuccessful) {
                    EmptyView()
                }
                .hidden() // Hides the EmptyView

            }//End of the VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the background color cover the full screen
            .background(Color("AppColor1")) // Set your desired color here
            .edgesIgnoringSafeArea(.all)

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
