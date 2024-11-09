//
//  OrderConfirmationView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 11/9/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct OrderConfirmationView: View {
    
    var body: some View {
        NavigationView {    // Wrap the view in a NavigationView
            ZStack {
                Image("PlainBG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Confirmation Icon
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("AppColor1"))
                    
                    // Thank You Text
                    Text("Thank you for your Order!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    // Confirmation Message
                    Text("Your meal order has been placed successfully. We are currently processing it now. You will receive a confirmation email shortly.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // View Your Order Button
                    NavigationLink(destination: CustomerOrderHistory()) {
                        Text("VIEW YOUR ORDER")
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color("AppColor4"))
                                    .stroke(Color("AppColor1"), lineWidth: 2)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .offset(y: -120)
                    
                    // Place a New Order Button
                    NavigationLink(destination: CustomerMenuView()) { // Replace with actual destination view
                        Text("PLACE A NEW ORDER")
                            .bold()
                            .foregroundStyle(Color("AppColor1"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color("AppColor3"), Color.white, Color("AppColor3")]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    .offset(y: -130)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// Preview
struct OrderConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        OrderConfirmationView()
    }
}
