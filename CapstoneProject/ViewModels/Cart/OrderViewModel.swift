//
//  OrderViewModel.swift
//  CapstoneProject
//
//  Created by kimi on 4/8/25.
//


import Foundation
import FirebaseFirestore

class OrderViewModel: ObservableObject {
    @Published var allOrders: [Order] = []
    @Published var userOrders: [Order] = []
    
    private var db = Firestore.firestore()
    
    // save new order from cart
    func placeOrder(customerId: String, cartItems: [CartItem]) {
        let newOrder = Order(
            customerId: customerId,
            items: cartItems,
            status: .orderPlaced,
            timestamp: Date()
        )
        
        do {
            _ = try db.collection("orders").addDocument(from: newOrder)
            print("order placed successfully.")
        } catch {
            print("failed to place order: \(error.localizedDescription)")
        }
    }
    
    // fetch all orders (staff view)
    func fetchAllOrders() {
        db.collection("orders")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                self.allOrders = docs.compactMap { try? $0.data(as: Order.self) }
            }
    }
    
    // fetch orders for a specific customer
    func fetchOrders(for customerId: String) {
        db.collection("orders")
            .whereField("customerId", isEqualTo: customerId)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                self.userOrders = docs.compactMap { try? $0.data(as: Order.self) }
            }
    }
    
    // update order status (staff use)
    func updateStatus(for orderId: String, to newStatus: OrderStatus) {
        db.collection("orders").document(orderId).updateData([
            "status": newStatus.rawValue
        ]) { error in
            if let error = error {
                print("failed to update order status: \(error)")
            } else {
                print("order \(orderId) status updated to \(newStatus.rawValue).")
            }
        }
    }
}
