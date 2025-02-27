//
//  NavigationBar.swift
//  CapstoneProject
//
//  Created by Kaleb on 11/5/24.
//  Modified by Alexis on 02/27/25.
//

import SwiftUI

struct NavigationBar: View {
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        HStack {
            navButton(destination: HomePageView(), label: "Home", icon: "house", selectedIcon: "house.fill", viewName: "HomePageView")
            navButton(destination: CustomerOrderHistory(), label: "Orders", icon: "book.closed", selectedIcon: "book.closed.fill", viewName: "CustomerOrderHistory")
            navButton(destination: MenuView(), label: "Menu", icon: "menucard", selectedIcon: "menucard.fill", viewName: "MenuView")
            navButton(destination: StoreView(), label: "Store", icon: "storefront", selectedIcon: "storefront.fill", viewName: "StoreView")
            navButton(destination: AcctProfile(), label: "Profile", icon: "person", selectedIcon: "person.fill", viewName: "AcctProfile")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.red.opacity(0.9))
                .shadow(radius: 5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }

    private func navButton<Destination: View>(destination: Destination, label: String, icon: String, selectedIcon: String, viewName: String) -> some View {
        NavigationLink(destination: destination.environmentObject(navigationManager)) {
            VStack {
                Image(systemName: navigationManager.currentView == viewName ? selectedIcon : icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
            .environmentObject(NavigationManager.shared)
    }
}
