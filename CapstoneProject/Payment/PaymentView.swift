//
//  PaymentView.swift
//  CapstoneProject
//
//  Created by Kaleb on 3/2/25.
//

import SwiftUI

struct PaymentView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var cardHolderName: String
    @Binding var cardNumber: String
    @Binding var expirationDate: String
    @Binding var cvv: String
    
    var body: some View {
        Form
        {
            TextField("Cardholder Name", text: $cardHolderName)
            TextField("Card Number", text: $cardNumber)
            TextField("Expiration Date", text: $expirationDate)
            TextField("CVV/CVC", text: $cvv)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Enter Credit Card Info")
    }
}
