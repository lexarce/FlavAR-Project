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
    
    var body: some View {
        NavigationView {    // Wrap the view in a NavigationView
            ZStack {
                Image("PlainBG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

// Preview
struct CustomerCheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerCheckoutView()
    }
}