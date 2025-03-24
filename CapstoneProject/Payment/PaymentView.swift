//
//  PaymentView.swift
//  CapstoneProject
//
//  Created by Kaleb on 3/2/25.
//

import SwiftUI

enum PaymentMethod: String, CaseIterable {
    case creditCard, debitCard, paypal, applePay, googlePay
}

struct PaymentView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var paymentMethodCompleted: Bool
    @State private var selectedPaymentMethod: PaymentMethod? = nil
    
    var body: some View {
        Form
        {
            Text("Select Payment Method")
                .font(.headline)
            
            PaymentMethodView(selectedPaymentMethod: $selectedPaymentMethod)
            
            if let method = selectedPaymentMethod {
                Section {
                    switch method {
                    case .creditCard:
                        CreditCardPaymentView(paymentMethodCompleted: $paymentMethodCompleted)
                    case .debitCard:
                        DebitCardPaymentView(paymentMethodCompleted: $paymentMethodCompleted)
                    case .paypal:
                        PayPalPaymentView(paymentMethodCompleted: $paymentMethodCompleted)
                    case .applePay:
                        ApplePayView()
                    case .googlePay:
                        GooglePayView()
                    }
                }
            }
        }
    }
}

// Modular Payment Method Selector View
struct PaymentMethodView: View {
    @Binding var selectedPaymentMethod: PaymentMethod?

    var body: some View {
        HStack(spacing: 5) {
            ForEach(PaymentMethod.allCases, id: \.self) { method in
                Button(action: {
                    selectedPaymentMethod = method
                }) {
                    Text(methodName(for: method))
                        .padding()
                        .font(.system(size: 14))
                        .fixedSize()
                        .frame(minWidth: 60, maxWidth: 60, minHeight: 40, maxHeight: 40)
                        .background(selectedPaymentMethod == method ? Color.blue : Color.white)
                        .foregroundColor(selectedPaymentMethod == method ? .white : .black)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
    }

    // Helper function to return appropriate icons
    private func methodName(for method: PaymentMethod) -> String {
        switch method {
            case .creditCard: return "Credit"
            case .debitCard: return "Debit"
            case .paypal: return "PayPal"
            case .applePay: return "Apple \nPay"
            case .googlePay: return "Google \nPay"
        }
    }
}



struct CreditCardPaymentView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var paymentMethodCompleted: Bool
    
    @State private var nameOnCard = ""
    @State private var cardNumber = ""
    @State private var expirationDate = ""
    @State private var cvv = ""
    @State private var showingError = false
    
    var body: some View {
        Text("Credit Card")
            .font(.headline)
        
        VStack {
            VStack(spacing: 16) {
                PaymentField(header: "Name on Card:", text: $nameOnCard)
                PaymentField(header: "Card Number:", text: $cardNumber)
                PaymentField(header: "Expiration Date (MM/YY):", text: $expirationDate)
                PaymentField(header: "CVV:", text: $cvv)
            }
            .padding()
            
            Button(action: {
                if !fieldsAreFilled() {
                    //Display a popup error message
                    showingError = true
                }
                else {
                    paymentMethodCompleted = true
                    dismiss()
                }
            }) {
                Text("Confirm Payment Method")
                    .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .alert("Credit Card Confirmation Failed", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please fill out all fields before proceeding.")
        }
    }
    
    private func fieldsAreFilled() -> Bool {
        return !nameOnCard.isEmpty &&
               !cardNumber.isEmpty &&
               !expirationDate.isEmpty &&
               !cvv.isEmpty
    }}

struct DebitCardPaymentView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var paymentMethodCompleted: Bool
    
    @State private var nameOnCard = ""
    @State private var cardNumber = ""
    @State private var expirationDate = ""
    @State private var cvv = ""
    @State private var billingAddress = ""
    @State private var showingError = false
    
    var body: some View {
        Text("Debit Card")
            .font(.headline)
        
        VStack {
            VStack(spacing: 16) {
                PaymentField(header: "Name on Card:", text: $nameOnCard)
                PaymentField(header: "Card Number:", text: $cardNumber)
                PaymentField(header: "Expiration Date (MM/YY):", text: $expirationDate)
                PaymentField(header: "CVV:", text: $cvv)
                PaymentField(header: "Billing Address:", text: $billingAddress)
            }
            .padding()
            
            Button(action: {
                if !fieldsAreFilled() {
                    //Display a popup error message
                    showingError = true
                }
                else {
                    paymentMethodCompleted = true
                    dismiss()
                }
            }) {
                Text("Confirm Payment Method")
                    .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .alert("Debit Card Confirmation Failed", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please fill out all fields before proceeding.")
        }
    }
    
    private func fieldsAreFilled() -> Bool {
        return !nameOnCard.isEmpty &&
               !cardNumber.isEmpty &&
               !expirationDate.isEmpty &&
               !cvv.isEmpty &&
               !billingAddress.isEmpty
    }
}

struct PayPalPaymentView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) private var openURL
    @Binding var paymentMethodCompleted: Bool
    
    var body: some View {
        Text("PayPal")
            .font(.headline)
        
        HStack {
            Spacer()
            
            Button("Go to PayPal") {
                openURL(URL(string: "https://www.paypal.com/signin")!)
                paymentMethodCompleted = true
                dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
        }
        
    }
}

struct ApplePayView: View {

    var body: some View {
        Text("Apple Pay View")
    }
}

struct GooglePayView: View {

    var body: some View {
        Text("Google Pay View")
    }
}

struct PaymentField: View {
    var header: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(header)
                .font(.subheadline)
                .font(.system(size: 13))
            TextField("", text: $text)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 1)
                )
                .frame(height: 40)
        }
            
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentView(paymentMethodCompleted: .constant(false))
        }
    }
}
