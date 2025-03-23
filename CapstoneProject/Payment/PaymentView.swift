//
//  PaymentView.swift
//  CapstoneProject
//
//  Created by Kaleb on 3/2/25.
//

import SwiftUI

struct PaymentView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var paymentMethodCompleted: Bool
    
    var body: some View {
        Form
        {

        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Choose a Payment Method")
    }
}
