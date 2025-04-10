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
                   
                    Text("Orders")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    
                    DividerView()
                    
                    OrdersTabSelector(selectedTab: $selectedTab)
                    
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

#Preview {
    let mockVM = OrderViewModel()
    return OrdersView(orderVM: mockVM)
}
