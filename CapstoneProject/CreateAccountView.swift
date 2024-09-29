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
    
    //Variables to be observed in real time
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var fullName: String = ""
    @State var phoneNumber: String = ""
    @State var emailAddress: String = ""
    @State var password: String = ""
    @State var confirmedPassword: String = ""
    @State private var errorMessage = ""
    @State private var isAccountCreated = false
    @State private var toLoginPage = false
    
    
    var body: some View {
        VStack {
            //A HStack stacks objects within it horizontally
            HStack {
                //A normal text field
                TextField("First Name", text: $firstName)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            //.stroke(Color.black, lineWidth: 2)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .autocorrectionDisabled(true)
                
                TextField("Last Name", text: $lastName)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            //.stroke(Color.black, lineWidth: 2)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .autocorrectionDisabled(true)
                
            }//End of HStack
            
            //Text field for the user to enter email address
            TextField("Email Address", text: $emailAddress)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        //.stroke(Color.black, lineWidth: 2)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .autocorrectionDisabled(true)
            
            //Phone Number Text Field
            TextField("Phone Number", text: $phoneNumber)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        //.stroke(Color.black, lineWidth: 2)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .autocorrectionDisabled(true)
            
            //Password text field
            SecureField("Password", text: $password)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        //.stroke(Color.black, lineWidth: 2)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .textContentType(.none)
                .keyboardType(.default)
                .autocorrectionDisabled(true)
                .autocapitalization(.none)
            
            //Confirm password text field
            SecureField("Confirm Password", text: $confirmedPassword)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        //.stroke(Color.black, lineWidth: 2)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .textContentType(.none)
                .keyboardType(.default)
                .autocorrectionDisabled(true)
                .autocapitalization(.none)
            
            
            //The sign in button
            Button {
                //If the input is formatted correctly, try to create the account
                if checkInput() == true {
                    createAccount(emailAddress: emailAddress, password: password) { success in
                        if success {//The account was created
                            isAccountCreated = true
                            print("Account created successfully!")
                            
                            //Create the database document to store this users info
                            createDocument()
                            
                            //Will cause the navigator to switch to LoginView
                            toLoginPage = true
                            
                        } else {//This means that the email was incorrect or improperly formatted
                            print("Failed to create account")
                            errorMessage = "Email Address is not formatted correctly or Email Address is already used for another account. Example: coolname@gmail.com"
                            // Show an alert with the error message or update the UI
                        }
                    }
                }
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
            
            //To display all the error messages from invalid input
            Text(errorMessage)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
            
            // NavigationLink to HomePageView
            NavigationLink(destination: LoginView(), isActive: $toLoginPage) {
                EmptyView()
            }
            .hidden() // Hides the EmptyView
            
            Text("Upon successful account creation, you will be redirected to the login page")
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .offset(y: 180)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
        }//End of VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the VStack fill the entire screen
        //This is how the page background gradually changes between 2 colors
        .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),  // Colors for the gradient
                        startPoint: .top,                             // Starting from the top
                        endPoint: .bottom                             // Transition to the bottom
                    )
                )
    }
    
    //Creates the document that holds the user information in firebase
    func createDocument() {
        // Add a new document with a generated ID
        do {
            let db = Firestore.firestore()
            fullName = firstName + lastName
            
            //The name of the document is the first and last name of the user
            let documentID = fullName.replacingOccurrences(of: " ", with: "_")
            
            db.document("users/\(documentID)").setData([
            "firstName": firstName,
            "lastName": lastName,
            "emailAddress": emailAddress,
            "phoneNumber": phoneNumber
            
          ])
        }
    }
    
    //Checks for invalid input from the user
    func checkInput() -> Bool {
        
        if firstName.count == 0 && lastName.count == 0 && emailAddress.count == 0 && phoneNumber.count == 0 && password.count == 0 && confirmedPassword.count == 0
        {
            errorMessage = "Please fill out all fields"
            return false
        }
        
        else if firstName.contains(" ") || lastName.contains(" ") || emailAddress.contains(" ") || phoneNumber.contains(" ") {
            errorMessage = "Name, email address, and phone number cannot contain spaces"
            return false
        }
        else if firstName.count > 50 {
            errorMessage = "First name character limit is 40"
            return false
        }
        else if lastName.count > 50 {
            errorMessage = "Last name character limit is 40"
            return false
        }
        
        let nonNumericCharacters = CharacterSet.decimalDigits.inverted
        let containsNonNumeric = phoneNumber.rangeOfCharacter(from: nonNumericCharacters) != nil
        
        if containsNonNumeric {
            errorMessage = "Phone number must contain only numbers"
            return false
        }
        
        if phoneNumber.count < 7 {
            errorMessage = "Phone Number is too short"
            return false
        }
        else if phoneNumber.count > 15 {
            errorMessage = "Phone Number is too long"
            return false
        }
        
        if password.count < 9 {
            errorMessage = "Password is too short"
            return false
        }
        else if password.count > 30 {
            errorMessage = "Password is too long"
            return false
        }
        
        if password != confirmedPassword {
            errorMessage = "Passwords do not match"
            return false
        }
        
        return true
    }
    
    //Function that creates the user account and stores the username and password for authentication in firebase. This allows user logins to be authenticated in LoginView
    func createAccount(emailAddress: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: emailAddress, password: password) { authResult, error in
            if let error = error {
                // Handle error
                errorMessage = error.localizedDescription
                completion(false) // Return false if there was an error
            } else {
                // Successfully created the account
                completion(true) // Return true if the account was created
            }
        }
    }
    
}

#Preview {
    CreateAccountView()
}
