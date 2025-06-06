//
//  MenuView.swift
//  CapstoneProject
//
//  Created by kimi on 11/22/24.
//  Modified by Alexis Arce on 02/17/25
//  Modified by Kimi on 4/3/25
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct MenuView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var userSessionViewModel: UserSessionViewModel
    @StateObject private var menuViewModel = MenuViewModel()
    
    @State private var searchText: String = ""
    @State private var selectedItem: MenuItem?
    @State private var showItemDetail = false
    @State private var showCreateMenuItem = false

    
    @Environment(\.dismiss) var dismiss
    
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
                        .onChange(of: searchText) { newValue in
                            if newValue.isEmpty {
                                menuViewModel.resetFilters()
                            } else {
                                menuViewModel.searchItems(newValue)
                            }
                        }
                    
                    DividerView()
                    
                    // Categories Header
                    Text("Categories")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 5)
                        .padding(.bottom, 10)
                    
                    // Horizontal Category Scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            // Filter by "Premium Jin's Box"
                            Button(action: {
                                menuViewModel.filterByCategory("Jin's Premium Boxes")
                            }) {
                                VStack {
                                    Image("PremiumBoxesIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 60)
                                    Text("Premium Jin's Box")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                                .padding(8)
                                .background(menuViewModel.selectedCategory == "Jin's Premium Boxes" ? Color.white.opacity(0.2) : Color.clear)
                                .cornerRadius(15)
                                
                            }
                            
                            // Filter by "Korean Food"
                            Button(action: {
                                menuViewModel.filterByCategory("Korean Food")
                            }) {
                                VStack {
                                    Image("KoreanFoodIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 60)
                                    Text("Korean Sides")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                                .padding(8)
                                .background(menuViewModel.selectedCategory == "Korean Food" ? Color.white.opacity(0.2) : Color.clear)
                                .cornerRadius(15)
                            }
                            
                            // Filter by "Popular"
                            Button(action: {
                                menuViewModel.filterByPopular()
                            }) {
                                VStack {
                                    Image("PopularIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 60)
                                    Text("Popular")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                                .padding(8)
                                .background(menuViewModel.isFilteringPopular ? Color.white.opacity(0.2) : Color.clear)
                                .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    DividerView()
                    
                    if userSessionViewModel.isAdmin {
                        HStack {
                            Spacer()
                            Button(action: {
                                showCreateMenuItem = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .background(Color(.systemGray5).opacity(0.25))
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                            .padding(.top, 10)
                            .padding(.trailing, 20)
                        }
                    }
                    
                    // Menu Items List (now from ViewModel)
                    /*MenuItemList(
                     menuItems: menuViewModel.filteredMenuItems,
                     searchText: searchText,
                     selectedItem: $selectedItem,
                     showItemDetail: $showItemDetail
                     )
                     .padding()*/
                    
                    List(menuViewModel.filteredMenuItems) { item in
                        NavigationLink(destination: IndividualItemView(menuItem: item)) {
                            HStack {
                                MenuItemImageView(imagePath: item.imagepath)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(10)
                                
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text("$\(item.price, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.bottom, 150)
                    
                    
                }
                .padding()
                
                // Bottom nav bar
                VStack {
                    Spacer()
                    NavigationBar()
                    Spacer().frame(height: 40)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("")
            .foregroundStyle(.white)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrowshape.backward")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CustomerCartView()
                        .environmentObject(CartManager.shared)
                        .environmentObject(NavigationManager.shared)) {
                        Image(systemName: "cart")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            userSessionViewModel.checkAdminStatus()
            navigationManager.currentView = "MenuView"
        }
        .sheet(isPresented: $showItemDetail) {
            if let selectedItem = selectedItem {
                IndividualItemView(menuItem: selectedItem)
            }
        }
        .fullScreenCover(isPresented: $showCreateMenuItem) {
            CreateMenuItemView()
        }

    }
}



#Preview
{
    MenuView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(UserSessionViewModel())
        .environmentObject(CartManager.shared)
        .environmentObject(OrderViewModel())
}

