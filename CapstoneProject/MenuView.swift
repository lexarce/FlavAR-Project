//
//  MenuView.swift
//  CapstoneProject
//
//  Created by kimi on 11/22/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct MenuView: View
{
    @State private var searchText: String = ""
    @State private var menuItems: [MenuItem] = []  // menu items from firebase
    @State private var isAdmin: Bool = false

    let menuItemService = MenuItemService()
    
    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                BackgroundView(imageName: "StaffMenuViewBG")
                
                
                VStack(alignment: .leading, spacing: 1)
                {
                    Spacer()
                        .frame(height: 80)
                    
                    // Jin BBQ Logo
                    HStack {
                        Image("JinBBQTakeout")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 90)
                            .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    
                    // line to separate
                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .padding(.horizontal,10)
                    
                    // search bar for items
                    SearchBar(searchText: $searchText)
                        . padding(.vertical,10)
                    
                    // line to separate
                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .padding(.horizontal,10)
                    
                    // ------- Categories -----------
                    // header
                    // TODO: change font
                    Text("Categories")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 5)
                        .padding(.bottom, 10)
                        .padding(.top, 10)
                    
                    // stack for item categories
                    // Use ScrollViewReader to allow scrolling to specific sections
                    ScrollViewReader { proxy in
                        // Stack for item categories
                        HStack(spacing: 12) {
                            Button(action: {
                                withAnimation {
                                    proxy.scrollTo("Premium Jin's Box", anchor: .top)
                                }
                            }) {
                                CategoryItemView(imageName: "PremiumBoxesIcon", categoryName: "Premium Jin's Box")
                            }

                            Button(action: {
                                withAnimation {
                                    proxy.scrollTo("Korean Food", anchor: .top)
                                }
                            }) {
                                CategoryItemView(imageName: "KoreanFoodIcon", categoryName: "Korean Food")
                            }

                            Button(action: {
                                withAnimation {
                                    proxy.scrollTo("Popular", anchor: .top)
                                }
                            }) {
                                CategoryItemView(imageName: "PopularIcon", categoryName: "Popular")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // center the HStack
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                    
                    // line to separate
                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .padding(.horizontal,10)
                    
                    if isAdmin{
                        // button for adding an item
                        AddButtonView()
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                    }
                    
                    MenuItemList()
                    
                    
                }
                .padding()
                
                
            }
        }
        .onAppear {
            // Fetch the admin status when the view appears
            checkUserAdminStatus { (isAdminStatus, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    // Update the admin status on the main thread
                    DispatchQueue.main.async {
                        self.isAdmin = isAdminStatus ?? false
                    }
                }
            }
        }
    }
}

// add item button
struct AddButtonView: View
{
    var body: some View
    {
        // Add item button wrapped in NavigationLink
        NavigationLink(destination: CreateMenuItemView()) {
            HStack(spacing: 20) {
                Spacer() // push button to the right

                Button(action: {
                    // You can put additional action code here if needed
                }) {
                    Image("PlusButton")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 10)
                        .padding(.top, 15)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct MenuItemList: View {
    @State private var menuItems: [MenuItem] = []
    private let menuItemService = MenuItemService()
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 1) {
                // ------- Categories -----------
                // header
                // TODO: change font
                Text("Popular")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading, 5)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .id("Popular")
                
                // line to separate
                Image("Line")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .padding(.horizontal,10)
                
                Text("Premium Jin's Box")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading, 5)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .id("Premium Jin's Box")
                
                // line to separate
                Image("Line")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .padding(.horizontal,10)
                
                // Loop through all the Jin's Box menu items and display them
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
                
                Text("Korean Food")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading, 5)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .id("Korean Food")
                
                // line to separate
                Image("Line")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .padding(.horizontal,10)
                
                
            }
        }
        .onAppear {
            menuItemService.fetchMenuItems { items in
                self.menuItems = items // Update the state with fetched menu items
            }
        }
    }
    
    // Formats the price of the menu item for display
    func formatPrice(_ price: Double) -> String {
        return String(format: "$%.2f", price)
    }
    
    // Loads all the menu items from the Firebase collection into an array.
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

/*struct MenuItemList: View {
    @State private var menuItems: [MenuItem] = [] // Store the menu items here
    @State private var groupedItems: [String: [MenuItem]] = [:] // Grouped menu items by category
    private let menuItemService = MenuItemService() // Initialize the service

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Loop through the grouped items
                ForEach(groupedItems.keys.sorted(), id: \.self) { category in
                    // Display category name
                    Text(category)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 5)
                        .padding(.bottom, 10)
                        .padding(.top, 10)
                    
                    // Line separator
                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                    
                    // Display the menu items for this category
                    ForEach(groupedItems[category]!, id: \.id) { item in
                        MenuItemView(imagePath: item.imagePath, title: item.title, description: item.description, price: "$\(item.price, specifier: "%.2f")")
                    }
                }
            }
            .padding(.horizontal, 10) // Add padding to the scrollable content
        }
        .onAppear {
            menuItemService.fetchMenuItems { items in
                self.menuItems = items // Update the state with fetched menu items
                groupItemsByCategory() // Group the items by category
            }
        }
    }

    // Group the menu items by category
    private func groupItemsByCategory() {
        var grouped: [String: [MenuItem]] = [:]
        for item in menuItems {
            // If the category doesn't exist in the dictionary, create an empty array
            if grouped[item.category] == nil {
                grouped[item.category] = []
            }
            grouped[item.category]?.append(item)
        }
        self.groupedItems = grouped
    }
}*/


// food item categories
struct CategoryItemView: View
{
    let imageName: String
    let categoryName: String
    
    var body: some View
    {
        VStack
        {
            // category icon
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            
            // category name
            Text(categoryName)
                .font(.caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}

// background image of page
struct BackgroundView: View {
    var imageName: String // image passed as parameter

    var body: some View {
        Image(imageName) // use the passed image name
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}

// search bar for menu items
struct SearchBar: View
{
    @Binding var searchText: String
    
    var body: some View
    {
        ZStack(alignment: .leading)
        {
            // placeholder text
            if searchText.isEmpty
            {
                Text("Your order?")
                    .foregroundColor(.white)
                    .padding(.leading, 40)
            }
            
            // actual textfield
            TextField("", text: $searchText)
                .padding()
                .foregroundColor(.white)
                .background(
                    LinearGradient(gradient: Gradient(colors: [
                        Color.black.opacity(0.3),
                        Color.white.opacity(0.1),
                        Color.black.opacity(0.3)
                    ]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 10)
        }
    }
}

#Preview
{
    MenuView()
}

