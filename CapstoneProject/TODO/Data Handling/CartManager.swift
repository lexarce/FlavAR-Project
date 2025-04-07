//
//  CartManager.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 1/29/25.
//

import SwiftUI
import Combine

class CartManager: ObservableObject {
    static let shared = CartManager()   // Singleton pattern instance
    
    @Published var cartItems: [CartItem] = []
    
    private init() {}

    func addToCart(_ menuItem: MenuItem) {
        let validID = menuItem.id ?? UUID().uuidString

        if let index = cartItems.firstIndex(where: { $0.id == validID }) {
            cartItems[index].quantity += 1
        } else {
            let newCartItem = CartItem(
                id: validID,
                title: menuItem.title,
                price: menuItem.price,
                imagepath: menuItem.imagepath,
                quantity: 1
            )
            cartItems.append(newCartItem)
        }
    }

    func removeFromCart(_ menuItem: MenuItem) {
        if let index = cartItems.firstIndex(where: { $0.id == menuItem.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            } else {
                cartItems.remove(at: index)
            }
        }
    }
    
    func increaseQuantity(for id: String) {
        if let index = cartItems.firstIndex(where: { $0.id == id }) {
            cartItems[index].quantity += 1
        }
    }

    func decreaseQuantity(for id: String) {
        if let index = cartItems.firstIndex(where: { $0.id == id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            } else {
                cartItems.remove(at: index)
            }
        }
    }

    func clearCart() {
        cartItems.removeAll()
    }
}

    
    /*// Calculate total price
    func totalPrice() -> Double {
        return cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }*/
