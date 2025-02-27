/*//
//  StaffMenuView.swift
//  CapstoneProject
//
//  Created by kimi on 10/12/24.
//
// NOTE: This file only exists so we can easily see how the staff view would look like. The
//       MenuView.swift will automatically check whether a user is an admin or not, and adjust
//       the UI.

import SwiftUI
import Firebase
import FirebaseFirestore

struct StaffMenuView: View
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
                    
                    // button for adding an item
                    AddButtonView()
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                    
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

#Preview
{
    StaffMenuView()
}

*/
