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
            statusGradient(for: order.status)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // header
                    Text("Order \(order.id.prefix(6))")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)

                    Text(order.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))

                    Divider().background(.white.opacity(0.3))

                    // item section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Items")
                            .font(.title2.bold())
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

                    // status
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
    }

    // returns a gradient view based on order status
    @ViewBuilder
    private func statusGradient(for status: OrderStatus) -> some View {
        switch status {
        case .completed:
            GradientBackgroundView(startHex: "#E6D4B5", endHex: "#b13337")
        case .readyForPickup:
            GradientBackgroundView(startHex: "#ff4232", endHex: "#b13337")
        case .orderPlaced:
            GradientBackgroundView(startHex: "#ffdda7", endHex: "#b13337")
        case .preparing:
            GradientBackgroundView(startHex: "#f1b14e", endHex: "#b13337")
        case .cancelled:
            GradientBackgroundView(startHex: "#888888", endHex: "#b13337")
        }
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


