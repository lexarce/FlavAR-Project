//
//  CartItem.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/27/25.
//

import SwiftUI
import Foundation

// Keeps cart separate from menu

struct CartItem: Identifiable {
    var id: String
    var title: String
    var price: Double
    let imagepath: String
    var quantity: Int

   /* init(menuItem: MenuItem, quantity: Int) {
        self.id = menuItem.id ?? UUID().uuidString
        self.title = menuItem.title
        self.price = menuItem.price
        self.quantity = quantity
    }*/
}
