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
    @Environment(\.dismiss) var dismiss
    @State private var isOrderPlaced = false
    @State private var orderError = false
    @State private var isProcessing = false
    @State var showingPaymentPage = false
    @State var paymentMethodCompleted = false

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
                    // Order Summary
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

                    // Payment Method Button
                    Button(action: {
                        showingPaymentPage = true
                    }) {
                        Text("Enter Payment Method")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AppColor4"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .offset(y: 50)

                    // Place Order Button
                    Button(action: {
                        if paymentMethodCompleted {
                            placeOrder()
                        } else {
                            orderError = true
                        }
                    }) {
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
                    .offset(y: 100)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .disabled(isProcessing)

                    Spacer()
                    NavigationBar()
                }
                .offset(y: 100)
                .alert("Order Placed!", isPresented: $isOrderPlaced) {
                    Button("OK") {
                        cartManager.clearCart()
                    }
                }
                .alert("Unable to place order", isPresented: $orderError) {
                    Button("OK") { }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("")
            .foregroundStyle(.white)
            .toolbar {
                // Title
                ToolbarItem(placement: .principal) {
                    Text("Checkout")
                        .font(.title2)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }

                // Back button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrowshape.backward")
                            .foregroundColor(.white)
                    }
                }

                // Cart button
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CustomerCartView()) {
                        Image(systemName: "cart")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingPaymentPage) {
                PaymentView(paymentMethodCompleted: $paymentMethodCompleted)
            }
        }
    }

    private func placeOrder() {
        isProcessing = true
        let orderData: [String: Any] = [
            "items": cartManager.cartItems.map { ["title": $0.title, "quantity": $0.quantity, "price": $0.price] },
            "subtotal": subtotal,
            "tax": tax,
            "total": total,
            "timestamp": Timestamp(date: Date())
        ]

        Firestore.firestore().collection("orders").addDocument(data: orderData) { error in
            isProcessing = false
            if error == nil {
                isOrderPlaced = true
            } else {
                orderError = true
            }
        }
    }
}

struct CustomerCheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        let cartManager = CartManager.shared
        cartManager.cartItems = [
            CartItem(id: "", title: "Sample Item", price: 9.99, imagepath: "", quantity: 2),
            CartItem(id: "", title: "Another Item", price: 14.50, imagepath: "", quantity: 1)
        ]
        let navigationManager = NavigationManager.shared

        return CustomerCheckoutView()
            .environmentObject(cartManager)
            .environmentObject(navigationManager)
            .previewLayout(.sizeThatFits)
    }
}

