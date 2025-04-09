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
    
    // delete a specific order
    func deleteOrder(_ orderId: String) {
        db.collection("orders").document(orderId).delete { error in
            if let error = error {
                print("failed to delete order: \(error)")
            } else {
                print("order deleted successfully.")
            }
        }
    }
    
    // cancel a specific order (must be done within a 5 second time frame)
    func cancelOrder(orderId: String, orderTimestamp: Date) {
        let now = Date()
        let timeSincePlaced = now.timeIntervalSince(orderTimestamp)
        
        // allow cancel only within 5 seconds
        if timeSincePlaced <= 5 {
            db.collection("orders").document(orderId).updateData([
                "status": OrderStatus.cancelled.rawValue
            ]) { error in
                if let error = error {
                    print("Failed to cancel order: \(error.localizedDescription)")
                } else {
                    print("Order \(orderId) cancelled within the allowed window.")
                }
            }
        } else {
            print("Too late to cancel. Order has already gone through.")
        }
    }

    
    // get the information for a specific order
    func getOrder(by id: String, completion: @escaping (Order?) -> Void) {
        db.collection("orders").document(id).getDocument { snapshot, error in
            if let doc = snapshot, doc.exists {
                let order = try? doc.data(as: Order.self)
                completion(order)
            } else {
                completion(nil)
            }
        }
    }

    // filters either all orders or a specific user's orders based on its status
    func filterOrders(by status: OrderStatus, from orders: [Order]) -> [Order] {
        return orders.filter { $0.status == status }
    }


}
