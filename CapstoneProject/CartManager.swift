//
//  CartManager.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 1/29/25.
//

import SwiftUI

class CartManager: ObservableObject {
    @Published var cartItems: [MenuItem] = []
    
    func addToCart(_ item: MenuItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity += 1
        } else {
            var newItem = item
            newItem.quantity = 1
            cartItems.append(newItem)
        }
    }
    
    func removeFromCart(_ item: MenuItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            } else {
                cartItems.remove(at: index)
            }
        }
    }
}
