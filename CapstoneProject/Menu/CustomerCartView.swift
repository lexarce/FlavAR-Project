//
//  CustomerCartView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 11/7/24.
//  Edited by Kimberly COstes 2/28/25
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct CustomerCartView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @ObservedObject var cartManager = CartManager.shared
    @Environment(\.dismiss) var dismiss

    
    private var subtotal: Double {
        cartManager.cartItems.reduce(0) { total, cartItem in
            total + (cartItem.price * Double(cartItem.quantity))
        }
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

                Spacer()
                
                VStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(cartManager.cartItems) { cartItem in
                                CartItemRow(cartItem: cartItem, cartManager: cartManager)
                            }
                        }
                    }
                    .padding(.top, 50)
                    
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
                    .padding(.bottom, 10)
                    
                    NavigationLink(destination: CustomerCheckoutView().environmentObject(cartManager)) {
                        Text("CHECK OUT")
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color("AppColor4"))
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    
                    NavigationBar()
                    Spacer().frame(height: 40)
                }
                .onAppear {
                    navigationManager.currentView = "CustomerCartView"
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("")
            .foregroundStyle(.white)
            .toolbar {
                // Title
                ToolbarItem(placement: .principal) {
                    Text("Cart")
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
                /*ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CustomerCartView()) {
                        Image(systemName: "cart")
                            .foregroundColor(.white)
                    }
                }*/
            }
        }
    }
}

struct CartItemRow: View {
    var cartItem: CartItem
    @ObservedObject var cartManager = CartManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let image = UIImage(named: cartItem.imagepath) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading) {
                    Text(cartItem.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("$\(cartItem.price, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    Button(action: { removeItem() }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.yellow)
                    }
                    
                    Text("\(cartItem.quantity)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Button(action: { addItem() }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
            Divider()
        }
        .padding(.horizontal)
    }
    
    
    func removeItem() {
        let menuItem = MenuItem(
            id: cartItem.id,
            title: cartItem.title,
            description: "",
            price: cartItem.price,
            imagepath: cartItem.imagepath,
            category: "", // default category
            isPopular: false, // default value
            isAvailable: true
        )
        cartManager.removeFromCart(menuItem)
    }


    func addItem() {
        let menuItem = MenuItem(
            id: cartItem.id,
            title: cartItem.title,
            description: "",
            price: cartItem.price,
            imagepath: cartItem.imagepath,
            category: "", // default category
            isPopular: false, // default value
            isAvailable: true
        )
        cartManager.addToCart(menuItem) // Pass as a MenuItem
    }
}

struct CustomerCartView_Previews: PreviewProvider {
    static var previews: some View {
        let mockCartManager = CartManager.shared
        mockCartManager.cartItems = [
            CartItem(id: "1", title: "Premium Bulgogi Box", price: 14.99, imagepath: "MenuItems/PremiumBeefBulgogiBox", quantity: 2),
            CartItem(id: "2", title: "Premium Japchae Box", price: 13.99, imagepath: "MenuItems/PremiumJapchaeBox", quantity: 1)
        ]
        
        return CustomerCartView()
            .environmentObject(mockCartManager)
            .environmentObject(NavigationManager.shared)
    }
}

