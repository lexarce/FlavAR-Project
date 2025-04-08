//
//  Order.swift
//  CapstoneProject
//
//  Created by kimi on 4/8/25.
//

import SwiftUI
import Foundation

struct Order: Identifiable, Codable {
    var id: String = UUID().uuidString
    var customerId: String
    var items: [CartItem]
    var status: OrderStatus
    var timestamp: Date = Date()
}

enum OrderStatus: String, Codable {
    case orderPlaced = "Order Placed"
    case preparing = "Preparing"
    case readyForPickup = "Ready for Pickup"
    case completed = "Completed"
}
