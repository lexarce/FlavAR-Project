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
                        CreditCardPaymentView()
                    case .debitCard:
                        DebitCardPaymentView()
                    case .paypal:
                        PayPalPaymentView()
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
                        .font(.system(size: 10))
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

    var body: some View {
        Text("Credit Card View")
    }
}

struct DebitCardPaymentView: View {

    var body: some View {
        Text("Debit Card View")
    }
}

struct PayPalPaymentView: View {

    var body: some View {
        Text("PayPal View")
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

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentView(paymentMethodCompleted: .constant(false))
        }
    }
}
