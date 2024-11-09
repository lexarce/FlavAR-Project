//
//  CustomerCheckoutView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 11/7/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct CustomerCheckoutView: View {
    @State private var selectedTime = Date() // Pickup time
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    private var subtotal: Double = 25.00 // Example subtotal
    private var tax: Double {
        subtotal * 0.1 // Example 10% tax
    }
    private var total: Double {
        subtotal + tax
    }
    
    enum PaymentMethod: String, CaseIterable {
        case creditCard = "Credit Card"
        case paypal = "PayPal"
        case googlePay = "Google Pay"
        case applePay = "Apple Pay"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("PlainBG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Checkout Title
                    Text("Checkout")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    
                    // Choose Time for Pickup
                    VStack(alignment: .leading) {
                        Text("Choose Time for Pickup")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        DatePicker("Pickup Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .padding(.horizontal)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Payment Methods Section
                    VStack(alignment: .leading) {
                        Text("Payment Method")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(PaymentMethod.allCases, id: \.self) { method in
                            HStack {
                                Image(systemName: selectedPaymentMethod == method ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(selectedPaymentMethod == method ? .yellow : .gray)
                                    .onTapGesture {
                                        selectedPaymentMethod = method
                                    }
                                
                                Text(method.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Subtotal, Tax, and Total Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Subtotal")
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(subtotal, specifier: "%.2f")")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Text("Tax")
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(tax, specifier: "%.2f")")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Text("Total")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(total, specifier: "%.2f")")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Place Order Button
                    Button {
                        // Handle place order action
                    } label: {
                        NavigationLink(destination: OrderConfirmationView()) {
                            Text("PLACE ORDER >")
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
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .offset(y: -60)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
}

// Preview
struct CustomerCheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerCheckoutView()
    }
}
