//
//  OrderDetailView.swift
//  CapstoneProject
//
//  Created by kimi on 4/8/25.
//


import SwiftUI

struct OrderDetailView: View {
    let order: Order

    var body: some View {
        ZStack {
            Color(hex: "#2D1B28").edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Order Details")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    Text("Order ID: \(order.id)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))

                    Divider().background(.white.opacity(0.3))

                    // 🧾 Items
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Items")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)

                        ForEach(order.items, id: \.id) { item in
                            HStack {
                                Text(item.title)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("x\(item.quantity)")
                                    .foregroundColor(.white)
                                Text("$\(item.price * Double(item.quantity), specifier: "%.2f")")
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Divider().background(.white.opacity(0.3))

                    // 🕐 Timestamp
                    HStack {
                        Text("Placed at:")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text(order.timestamp.formatted(date: .abbreviated, time: .shortened))
                            .foregroundColor(.white)
                    }

                    // 🔄 Status
                    HStack {
                        Text("Status:")
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text(order.status.rawValue)
                            .bold()
                            .foregroundColor(.white)
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Order #\(order.id.prefix(6))")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockOrder = Order(
            customerId: "123",
            items: [
                CartItem(id: "1", title: "Premium Bulgogi Box", price: 14.99, imagepath: "", quantity: 2),
                CartItem(id: "2", title: "Japchae Box", price: 13.99, imagepath: "", quantity: 1),
                CartItem(id: "3", title: "Kimchi", price: 1.99, imagepath: "", quantity: 3)
            ],
            status: .readyForPickup,
            timestamp: Date()
        )

        return NavigationStack {
            OrderDetailView(order: mockOrder)
        }
        .preferredColorScheme(.light)
    }
}
