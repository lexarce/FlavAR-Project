//
//  CustomerMenuView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 10/7/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct CustomerMenuView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    // Observed array to hold menu items
    @State private var menuItems: [MenuItem] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("CustomerOrderMenuBG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Top bar with back button & cart button
                    HStack {
                        // Back button to navigate to HomePageView
                        NavigationLink(destination: HomePageView()) {
                            Image("BackButton")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                        Spacer()
                        
                        // Cart button to navigate to CustomerCartView
                        NavigationLink(destination: CustomerCartView()) {
                            Image("CartButton")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Spacer().frame(height: 70)
                            
                            Text("Premium Jin's Box")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.leading)
                            
                            // For each menu item, create a MenuItemView
                            ForEach(menuItems) { item in
                                NavigationLink(destination: IndividualItemView(menuItem: item)) {
                                    MenuItemView(
                                        imagePath: item.imagePath,
                                        title: item.title,
                                        description: item.description,
                                        price: formatPrice(item.price)
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    // Use NavigationBar component
                    NavigationBar()
                    
                    Spacer().frame(height: 40)
                }
            }
            .onAppear {
                loadMenuItems()
                
                navigationManager.currentView = "CustomerMenuView"
            }
        }
    }
    
    // Formats the price of the menu item for display
    func formatPrice(_ price: Double) -> String {
        return String(format: "$%.2f", price)
    }
    
    // Loads all the menu items from the Firebase collection into an array
    // Each MenuItem has its own title, description, price, and imagePath
    func loadMenuItems() {
        let menuItemService = MenuItemService()
        
        menuItemService.fetchMenuItems { items in
            DispatchQueue.main.async {
                self.menuItems = items
            }
        }
    }
}

// Separate view for each menu item
struct MenuItemView: View {
    
    var imagePath: String
    var title: String
    var description: String
    var price: String
    
    @State private var downloadedImage: UIImage? = nil
    
    var body: some View {
        HStack {
            if let image = downloadedImage {
                Image(uiImage: image)  // Display downloaded image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            } else {
                // Placeholder or loading image
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                Text(price)
                    .font(.body)
                    .foregroundColor(.yellow)
            }
            Spacer()
        }
        .padding()
        .background(Color("ContainerColor"))
        .cornerRadius(15)
        .shadow(radius: 5)
        .onAppear {
            loadImage()  // Download the image when the view appears
        }
    }
    
    // Loads the image with the given imagePath from Firebase
    func loadImage() {
        let imageDownloader = ImageDownloader()
        imageDownloader.downloadImage(from: imagePath) { uiImage in
            DispatchQueue.main.async {
                self.downloadedImage = uiImage  // Update the image state
            }
        }
    }
}

// Preview
struct CustomerMenuView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerMenuView()
            .environmentObject(NavigationManager.shared)
    }
}
