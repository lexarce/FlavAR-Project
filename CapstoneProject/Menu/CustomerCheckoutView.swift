//
//  CustomerCheckoutView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 11/7/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CustomerCheckoutView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var isOrderPlaced = false
    @State private var isProcessing = false

    private var subtotal: Double {
        cartManager.cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    private var tax: Double {
        subtotal * 0.1 // Example 10% tax
    }
    
    private var total: Double {
        subtotal + tax
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("PlainBG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("CHECKOUT")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Subtotal")
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(subtotal, specifier: "%.2f")")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Text("Tax (10%)")
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(tax, specifier: "%.2f")")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Text("Total")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(total, specifier: "%.2f")")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Button(action: placeOrder) {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("PLACE ORDER")
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 30).fill(Color("AppColor4")))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .disabled(isProcessing)

                    NavigationBar()
                }
                .alert("Order Placed!", isPresented: $isOrderPlaced) {
                    Button("OK") {
                        cartManager.clearCart()
                    }
                }
            }
        }
    }
    
    private func placeOrder() {
        isProcessing = true
        let orderData = [
            "items": cartManager.cartItems.map { ["title": $0.title, "quantity": $0.quantity, "price": $0.price] },
            "subtotal": subtotal,
            "tax": tax,
            "total": total,
            "timestamp": Timestamp(date: Date())
        ] as [String: Any]

        Firestore.firestore().collection("orders").addDocument(data: orderData) { error in
            isProcessing = false
            if error == nil {
                isOrderPlaced = true
            }
        }
    }
}

