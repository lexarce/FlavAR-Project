//
//  MenuView.swift
//  CapstoneProject
//
//  Created by kimi on 11/22/24.
//  Modified by Alexis Arce on 02/17/25
//

import SwiftUI
import Firebase
import FirebaseFirestore

// Main menu screen with categories, search bar, & item list

struct MenuView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var searchText: String = ""
    @State private var menuItems: [MenuItem] = []
    @State private var isAdmin: Bool = false
    @State private var selectedItem: MenuItem?
    @State private var showItemDetail = false

    let menuItemService = MenuItemService()

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(imageName: "StaffMenuViewBG")

                VStack(alignment: .leading, spacing: 1) {
                    Spacer().frame(height: 80)

                    // Jin BBQ Logo
                    HStack {
                        Image("JinBBQTakeout")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 90)
                            .padding(.top, -50)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    DividerView()

                    // Search bar
                    SearchBar(searchText: $searchText)
                        .padding(.vertical, 10)

                    DividerView()

                    // Categories
                    Text("Categories")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 5)
                        .padding(.bottom, 10)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryLinkView(destination: PremiumJinsBox(), imageName: "PremiumBoxesIcon", categoryName: "Premium Jin's Box")
                            CategoryLinkView(destination: KoreanFood(), imageName: "KoreanFoodIcon", categoryName: "Korean Food")
                            CategoryLinkView(destination: PopularItems(), imageName: "PopularIcon", categoryName: "Popular")
                        }
                        .padding(.horizontal)
                    }

                    DividerView()

                   /* if isAdmin {
                        AddButtonView().padding(.bottom, 2)
                    }*/

                    MenuItemList(menuItems: menuItems, searchText: searchText, selectedItem: $selectedItem, showItemDetail: $showItemDetail)
                }
                .padding()

                VStack { Spacer(); NavigationBar() }
            }
            // Top toolbar
            .navigationBarBackButtonHidden(true)
            .navigationTitle("")
            .foregroundStyle(.white)
            .toolbar {
                // Title
                ToolbarItem(placement: .principal) {
                    Text("")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                // Back button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        navigationManager.currentView = "MenuView"
                    }) {
                        Image(systemName: "arrowshape.backward")
                            .foregroundColor(.white)
                    }
                }
                // Cart button
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CustomerCartView()) {
                        Image(systemName: "cart")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            menuItemService.fetchMenuItems { items in self.menuItems = items }
            checkUserAdminStatus { isAdmin, _ in self.isAdmin = isAdmin ?? false}
            navigationManager.currentView = "MenuView"
        }
        .sheet(isPresented: $showItemDetail) {
            if let selectedItem = selectedItem {
                IndividualItemView(menuItem: selectedItem)
            }
        }
    }
}


#Preview
{
    MenuView()
        .environmentObject(NavigationManager.shared)
}

