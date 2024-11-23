//
//  CustomerCartView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 11/7/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct CustomerCartView: View {
    @State private var cartItems: [MenuItem] = []
    @State private var quantities: [String: Int] = [:] // Track quantities by item ID
    @State private var showDetails: [String: Bool] = [:] // Track show/hide state for item details
    
    private var subtotal: Double {
        cartItems.reduce(0) { $0 + ($1.price * Double(quantities[$1.id] ?? 1)) }
    }
    
    private var tax: Double {
        subtotal * 0.1 // Example 10% tax
    }
    
    private var total: Double {
        subtotal + tax
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("PlainBG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Top bar with back button & cart button
                    HStack {
                        // Back button to navigate to CustomerMenuView
                        NavigationLink(destination: CustomerMenuView()) {
                            Image("BackButton")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                        Spacer()
                        
                        // Exit button to navigate to HomePageView
                        NavigationLink(destination: HomePageView()) {
                            Image("ExitButton")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    Spacer(minLength: 1) // Adds space above Cart title

                    // Cart Title
                    Text("CART")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                    
                    // Item List
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(cartItems) { item in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        if let image = UIImage(named: item.imagePath) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(8)
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray)
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(8)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(item.title)
                                                .font(.headline)
                                                .foregroundColor(.white)  // Title color
                                            
                                            Text("$\(item.price, specifier: "%.2f")")
                                                .font(.subheadline)
                                                .foregroundColor(.yellow)  // Price color
                                        }
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 10) {
                                            Button(action: {
                                                if let currentQuantity = quantities[item.id], currentQuantity > 1 {
                                                    quantities[item.id] = currentQuantity - 1
                                                }
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .foregroundColor(.yellow) // Updated to yellow
                                            }
                                            
                                            Text("\(quantities[item.id] ?? 1)")
                                                .font(.subheadline)
                                                .foregroundColor(.white)  // Quantity color
                                            
                                            Button(action: {
                                                quantities[item.id, default: 1] += 1
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .foregroundColor(.yellow) // Updated to yellow
                                            }
                                        }
                                    }
                                    
                                    // View Details Button
                                    Button(action: {
                                        withAnimation {
                                            showDetails[item.id] = !(showDetails[item.id] ?? false)
                                        }
                                    }) {
                                        Text(showDetails[item.id] == true ? "Hide Details" : "View Details")
                                            .font(.subheadline)
                                            .foregroundColor(.gray) // Set to gray
                                    }
                                    
                                    // Item Details
                                    if showDetails[item.id] == true {
                                        Text(item.description)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(.top, 4)
                                    }
                                    
                                    Divider()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top, 5) // Add space above the item list

                    Spacer() // Add spacer to push the content up from the bottom
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Add Items Button
                        NavigationLink(destination: CustomerMenuView()) {
                            Image("AddItemButtonClear")
                                .resizable()
                                .frame(width: 100, height: 50)
                                .padding(.bottom, -10)
                                .padding(.top, -10)
                        }
                    }
                    
                    Spacer()
                    
                    // Subtotal, Tax, and Total
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack {
                            Text("Subtotal")
                                .foregroundColor(.white)  // Label color
                            Spacer()
                            Text("$\(subtotal, specifier: "%.2f")")
                                .foregroundColor(.white)  // Value color
                        }
                        HStack {
                            Text("Tax")
                                .foregroundColor(.white)  // Label color
                            Spacer()
                            Text("$\(tax, specifier: "%.2f")")
                                .foregroundColor(.white)  // Value color
                        }
                        HStack {
                            Text("Total")
                                .fontWeight(.bold)
                                .foregroundColor(.white)  // Label color
                            Spacer()
                            Text("$\(total, specifier: "%.2f")")
                                .fontWeight(.bold)
                                .foregroundColor(.white)  // Value color
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 60)
                    
                    // Checkout Button
                    NavigationLink(destination: CustomerCheckoutView()) {
                        // Handle checkout action
                        Text("CHECK OUT")
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color("AppColor4"))
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom,20)
                    .offset(y: -60)
                }
                .onAppear {
                    loadCartItems()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
            }
        }
    }
    
    // Load cart items from Firebase
    func loadCartItems() {
        let menuItemService = MenuItemService()
        menuItemService.fetchMenuItems { items in
            DispatchQueue.main.async {
                self.cartItems = items
                // Initialize quantities and showDetails dictionaries for each item
                for item in items {
                    self.quantities[item.id] = 1 // Default quantity
                    self.showDetails[item.id] = false // Default details hidden
                }
            }
        }
    }
}

// Preview
struct CustomerCartView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerCartView()
    }
}
