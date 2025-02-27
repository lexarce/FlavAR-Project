//
//  PremiumJinsBox.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/27/25.
//

import SwiftUI
import FirebaseFirestore

struct PremiumJinsBox: View {
    @StateObject private var menuViewModel = MenuViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    @ObservedObject var cartManager = CartManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("PlainBG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    List(menuViewModel.menuItems) { item in
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
                    
                    NavigationBar()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("")
            .foregroundStyle(.white)
            .toolbar {
                // Title
                ToolbarItem(placement: .principal) {
                    Text("Premium Jin's Box")
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
                
                // Cart Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CustomerCartView()) {
                        Image(systemName: "cart")
                            .foregroundColor(.white)
                    }
                }
            }
            .onAppear() {
                menuViewModel.fetchMenuItems()
                navigationManager.currentView = "PremiumJinsBox"
            }
        }
    }
}


#Preview {
    PremiumJinsBox()
        .environmentObject(NavigationManager.shared)
        .environmentObject(CartManager.shared)
}
