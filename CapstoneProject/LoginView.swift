//
//  LoginView.swift
//  CapstoneProject
//
//  Created by Kaleb on 9/23/24.
//

import SwiftUI

struct LoginView: View {
    @State var emailInput: String = ""
    @State var passwordInput: String = ""
    
    
    var body: some View {
        
        //Use this to manage page changes
        NavigationStack {
            VStack {
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
                
                Text("Password")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                
                //A text field that censors the text
                SecureField("Enter Password", text: $passwordInput)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                            .stroke(Color.black, lineWidth: 2)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                
                    //.padding(.bottom, 10)
                
                Button {
                    //This is what will happen when we press "Forgot Password"
                    
                } label: {//This is the physical button
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

            }//End of the VStack
            
        }//End of Navigation Stack
        
        
    }
        
        
    
}

#Preview {
    LoginView()
}
