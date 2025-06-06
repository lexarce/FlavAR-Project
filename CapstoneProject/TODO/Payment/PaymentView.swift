//
//  PaymentView.swift
//  CapstoneProject
//
//  Created by Kaleb on 3/2/25.
//

import SwiftUI
import PassKit

enum PaymentMethod: String, CaseIterable {
    case creditCard, debitCard, paypal, applePay
}

var buttonColor: Color {
    Color(red: 211 / 255, green: 126 / 255, blue: 116 / 255)
}

struct PaymentView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var paymentMethodCompleted: Bool
    @State private var selectedPaymentMethod: PaymentMethod? = nil
    
    var formColor: Color {
            Color(red: 150 / 255, green: 59 / 255, blue: 51 / 255)
    }
    var sectionColor: Color {
        Color(red: 166 / 255, green: 77 / 255, blue: 65 / 255)
    }
    
    var body: some View {
        Form
        {
            Section {
                Text("Select Payment Method")
                    .font(.headline)
                    .foregroundColor(.white)
                
                PaymentMethodView(selectedPaymentMethod: $selectedPaymentMethod)
            }
            .listRowBackground(sectionColor)
            
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
                        ApplePayView(paymentMethodCompleted: $paymentMethodCompleted)
                    }
                }
                .listRowBackground(sectionColor)
            }
        }
        .scrollContentBackground(.hidden)
        .background(formColor)
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
                        .frame(minWidth: 70, maxWidth: 70, minHeight: 50, maxHeight: 50)
                        .background(selectedPaymentMethod == method ? buttonColor : Color.white)
                        .foregroundColor(selectedPaymentMethod == method ? .white : .black)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(buttonColor, lineWidth: 1)
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
            case .applePay: return "Apple \nPay"        }
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
            .foregroundColor(.white)
        
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
                        .background(buttonColor)
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
            .foregroundColor(.white)
        
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
                        .background(buttonColor)
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
            .foregroundColor(.white)
        
        HStack {
            Spacer()
            
            Button("Go to PayPal") {
                openURL(URL(string: "https://www.paypal.com/signin")!)
                paymentMethodCompleted = true
                dismiss()
            }
            .padding()
            .background(buttonColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
        }
        
    }
}

struct ApplePayView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @Binding var paymentMethodCompleted: Bool
    
    var body: some View {
        Text("Apple Pay")
            .font(.headline)
            .foregroundColor(.white)

        HStack {
            Spacer()
            ApplePayButton(showAlert: $showAlert, paymentMethodCompleted: $paymentMethodCompleted)
                .frame(width: 200, height: 50)
            Spacer()
        }
        .alert("Apple Pay Successful!", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
            
    }
    
    private struct ApplePayButton: UIViewRepresentable {
        @Binding var showAlert: Bool
        @Binding var paymentMethodCompleted: Bool
        
        func makeUIView(context: Context) -> PKPaymentButton {
            let button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
            button.addTarget(context.coordinator, action: #selector(Coordinator.simulatePayment), for: .touchUpInside)
            return button
        }

        func updateUIView(_ uiView: PKPaymentButton, context: Context) {}

        func makeCoordinator() -> Coordinator {
            Coordinator(showAlert: $showAlert)
        }

        class Coordinator: NSObject {
            var showAlert: Binding<Bool>

            init(showAlert: Binding<Bool>) {
                self.showAlert = showAlert
            }

            @objc func simulatePayment() {
                showAlert.wrappedValue = true
            }
        }
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
                .foregroundColor(.white)
            TextField("", text: $text)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 2)
                        .fill(Color.white)
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
