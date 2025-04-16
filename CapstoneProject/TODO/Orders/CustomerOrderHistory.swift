//
//  CustomerOrderHistory.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 11/9/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct CustomerOrderHistory: View {
    
    var body: some View {
        NavigationView {    
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
struct CustomerOrderHistory_Previews: PreviewProvider {
    static var previews: some View {
        CustomerOrderHistory()
    }
}
