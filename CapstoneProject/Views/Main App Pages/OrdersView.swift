//
//  OrdersView.swift
//  CapstoneProject
//
//  Created by kimi on 4/9/25.
//

import SwiftUI

enum OrderTab {
    case inProgress
    case completed
}

struct OrdersView: View {
    
    @ObservedObject var orderVM: OrderViewModel
    @EnvironmentObject var userSessionVM: UserSessionViewModel
    @State private var selectedTab: OrderTab = .inProgress
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // background color changes depending on the tab chosen
                GradientBackgroundView(
                    startHex: selectedTab == .inProgress ? "#1a0d14" : "1a0d14",
                    endHex: selectedTab == .inProgress ? "#4C0f0E" : "#42292D"
                ).animation(.easeInOut(duration: 0.5), value: selectedTab)
                
                VStack {
                   
                    Spacer(minLength: 90)
                    
                    Text("Orders")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    
                    DividerView()
                    
                    OrdersTabSelector(selectedTab: $selectedTab)
                    
                    ScrollView {
                        
                        let source = userSessionVM.isAdmin ? orderVM.allOrders : orderVM.userOrders
                        let filtered = orderVM.filterOrders(by: selectedTab, from: source)
                        
                        // order cards
                        VStack(spacing: 16) {
                            ForEach(filtered, id: \.id) { order in
                                let colors = getCardColors(for: order.status, tab: selectedTab)

                                OrderCardView(
                                    orderId: String(order.id.prefix(8)),
                                    customerName: "Unknown", // replace with real name if stored in Order
                                    itemCount: order.items.count,
                                    timestamp: order.timestamp,
                                    backgroundColor: colors.background,
                                    orderTitleColor: colors.titleColor,
                                    detailsColor: colors.detailsColor
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

                if !isPreview {
                    if userSessionVM.isAdmin {
                        orderVM.fetchAllOrders()
                    } else if let user = userSessionVM.userInfo {
                        orderVM.fetchOrders(for: user.id)
                    }
                }
            }

        }
    }
}

// view for the selection tab
struct OrdersTabSelector: View {
    @Binding var selectedTab: OrderTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach([OrderTab.inProgress, .completed], id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedTab = tab
                    }
                }) {
                    Text(tab == .inProgress ? "In Progress" : "Completed")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .foregroundColor(Color(hex: "#C04132")) // muted red
                        .background(
                            ZStack {
                                if selectedTab == tab {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color(hex: "#FFDEB2")) // slightly lighter fill
                                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                                        .transition(.scale)
                                }
                            }
                        )
                }
            }
        }
        .padding(4)
        .background(Color(hex: "#ffcb7a"))
        .clipShape(Capsule())
        .padding(.horizontal)
    }
}

// order card views
struct OrderCardView: View {
    let orderId: String
    let customerName: String
    let itemCount: Int
    let timestamp: Date
    //let note: String
    
    let backgroundColor: Color
    let orderTitleColor: Color
    let detailsColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Order \(orderId)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(orderTitleColor)
            
            Text("\(customerName)\n\(itemCount) items")
                .font(.subheadline)
                .foregroundColor(detailsColor)
                .lineLimit(2)
                .bold()
            
            Spacer()
            Text(timestamp.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundColor(.black)
                .bold()
            
            // might implement this logic later
            // Text(note)
            //    .font(.caption.bold())
            //    .foregroundColor(orderTitleColor)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

// for setting color scheme of cards
struct OrderCardColorScheme {
    let background: Color
    let titleColor: Color
    let detailsColor: Color
}

// determining card color schemes
func getCardColors(for status: OrderStatus, tab: OrderTab) -> OrderCardColorScheme {
    switch tab {
    case .inProgress:
        switch status {
        case .orderPlaced:
            return OrderCardColorScheme(
                background: Color(hex: "#ffdda7"),
                titleColor: Color(hex: "#9d2b38"),
                detailsColor: Color(hex: "#bc606d")
            )
        case .preparing:
            return OrderCardColorScheme(
                background: Color(hex: "#f1b14e"),
                titleColor: Color(hex: "#9d2b38"),
                detailsColor: Color(hex: "#bc606d")
            )
        case .readyForPickup:
            return OrderCardColorScheme(
                background: Color(hex: "#eb4b3a"),
                titleColor: Color(hex: "#fdc671"),
                detailsColor: Color(hex: "#ffdfaf")
            )
        default:
            return OrderCardColorScheme(
                background: .gray,
                titleColor: .white,
                detailsColor: .white
            )
        }

    case .completed:
        return OrderCardColorScheme(
            background: Color(hex: "#c6b4b4"),
            titleColor: Color(hex: "#e4e4e4"),
            detailsColor: Color(hex: "#e4e4e4")
        )
    }
}


// mock orders view
#Preview {
    let mockVM = OrderViewModel()
    mockVM.allOrders = [
        Order(
            customerId: "123",
            items: [
                CartItem(id: "1", title: "Premium Bulgogi Box", price: 14.99, imagepath: "", quantity: 2)
            ],
            status: .orderPlaced,
            timestamp: Date()
        ),
        Order(
            customerId: "456",
            items: [
                CartItem(id: "2", title: "Japchae Box", price: 13.99, imagepath: "", quantity: 1)
            ],
            status: .completed,
            timestamp: Date()
        ),
        Order(
            customerId: "456",
            items: [
                CartItem(id: "2", title: "Japchae Box", price: 13.99, imagepath: "", quantity: 1)
            ],
            status: .preparing,
            timestamp: Date()
        ),
        Order(
            customerId: "456",
            items: [
                CartItem(id: "2", title: "Japchae Box", price: 13.99, imagepath: "", quantity: 1)
            ],
            status: .readyForPickup,
            timestamp: Date()
        )
    ]

    let mockSession = UserSessionViewModel()
    mockSession.userInfo = UserInfo(
        id: "123",
        firstName: "Test",
        lastName: "User",
        emailAddress: "test@example.com",
        phoneNumber: "1234567890",
        isAdmin: true // or false if you want to simulate a customer
    )
    mockSession.isAdmin = true

    return OrdersView(orderVM: mockVM)
        .environmentObject(mockSession)
}
