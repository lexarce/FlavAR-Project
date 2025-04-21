//
//  IndividualItemView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 10/23/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

// Shows pop-up details when an item is tapped

struct IndividualItemView: View {
    var menuItem: MenuItem
    @State private var isARViewPresented: Bool = false
    @State private var downloadedImage: UIImage? = nil
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var customizationVM = CustomizationViewModel()
    @State private var showCustomizationSheet = false
    
    
    var body: some View {
        ZStack {
            Image("PlainBG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if let image = downloadedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 200)
                        .cornerRadius(20)
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 300, height: 200)
                        .cornerRadius(20)
                }
                
                Button(action: {
                    isARViewPresented.toggle()
                }) {
                    Text("View in AR")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("AppColor4"))
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isARViewPresented) {
                    SheetView(isPresented: $isARViewPresented, modelName: menuItem.ARModelPath ?? "shoe")
                }
                
                Text(menuItem.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(menuItem.description)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                
                // Only show if the item has customizations
                if ["PremiumBeefBulgogiBox", "PremiumJapchaeBox", "PremiumPorkBellyBox", "PremiumSpicyPorkBox"].contains(menuItem.id ?? "") {
                    Button(action: {
                        showCustomizationSheet = true
                    }) {
                        Text("Customize Your Order")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("AppColor4"))
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showCustomizationSheet) {
                        if let id = menuItem.id {
                            CustomizationSheetView(viewModel: customizationVM, basePrice: menuItem.price)
                                .onAppear {
                                    customizationVM.fetchCustomizations(for: id)
                                }
                        }
                    }
                }

                
                // Customizations
                ForEach(customizationVM.customizations) { category in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(category.categoryName)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(category.options) { option in
                            HStack {
                                Text(option.name)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if let cost = option.additionalCost, cost > 0 {
                                    Text("+$\(cost, specifier: "%.2f")")
                                        .foregroundColor(.yellow)
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Text("$\(menuItem.price, specifier: "%.2f")")
                    .font(.title3)
                    .foregroundColor(.yellow)
                    .padding()
                
                Divider()
                
                Button(action: {
                    if let _ = menuItem.id {
                        cartManager.addToCart(menuItem)
                        showSuccessAlert = true
                    } else {
                        showErrorAlert = true
                    }
                }) {
                    Text("ADD TO CART")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color("AppColor4"))
                        )
                }
                .padding(.horizontal, 20)
                .shadow(radius: 10)
                .alert("Success", isPresented: $showSuccessAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Successfully added to cart!")
                }
                .alert("Error", isPresented: $showErrorAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Something went wrong. Please try again.")
                }
                
            }
            //.padding(.top, 10)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .foregroundStyle(.white)
        .toolbar {
            // Centered title
            ToolbarItem(placement: .principal) {
                Text("Item Details")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            // Back button
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrowshape.backward")
                        .foregroundColor(.white)
                }
            }
            
            // Cart
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: CustomerCartView()
                    .environmentObject(CartManager.shared)
                    .environmentObject(NavigationManager.shared)) {
                    Image(systemName: "cart")
                        .foregroundColor(.white)
                }
            }
        }
        
        .onAppear {
            loadImage()
            if let id = menuItem.id {
                customizationVM.fetchCustomizations(for: id)
            }
        }
    }
    
    
    func loadImage() {
        let imageDownloader = ImageDownloader()
        imageDownloader.downloadImage(from: menuItem.imagepath) { uiImage in
            DispatchQueue.main.async {
                self.downloadedImage = uiImage
            }
        }
    }
}

struct IndividualItemView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMenuItem = MenuItem(
            id: "1",
            title: "Premium Beef Bulgogi Box",
            description: "Delicious beef bulgogi served with rice, vegetables, and sauce.",
            price: 14.99,
            imagepath: "PremiumBulgogiBox",
            category: "Jin's Box",
            isPopular: true,
            isAvailable: true
        )
        
        
        return IndividualItemView(menuItem: sampleMenuItem)
            .environmentObject(CartManager.shared) // changed CartManager() to CartManager.shared - EDITED BY KIMI
            .previewLayout(.sizeThatFits)
            .background(Color.black)
    }
}
