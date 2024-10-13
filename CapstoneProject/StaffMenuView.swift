//
//  StaffMenuView.swift
//  CapstoneProject
//
//  Created by kimi on 10/12/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct StaffMenuView: View 
{
    @State private var searchText: String = ""
    @State private var menuItems: [MenuItem] = []  // menu items from firebase

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
                    // search bar for items
                    SearchBar(searchText: $searchText)
                    
                    // buttons for adding items and categories
                    ButtonGroupView()
                    
                    // line to separate
                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                    
                    // ------- Categories -----------
                    // header
                    // TODO: change font
                    Text("Categories")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    // stack for item categories
                    // TODO: center
                    HStack(spacing: 20) {
                        CategoryItemView(imageName: "PremiumBoxesIcon", categoryName: "Premium Jin's Box")
                        CategoryItemView(imageName: "KoreanFoodIcon", categoryName: "Korean Food")
                        CategoryItemView(imageName: "PopularIcon", categoryName: "Popular")
                    }
                    .padding(.horizontal)
                    
                    // line to separate
                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                    
                    
                    
                }
                .padding()
                
                
            }
        }
    }
}

// add category and item buttons
struct ButtonGroupView: View 
{
    var body: some View 
    {
        HStack(spacing: 20) 
        {
            Button(action: {
                // write action here
            }) {
                Image("AddCategoryButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 100)
                    .padding()
            }

            Button(action: {
                // write action here
            }) {
                Image("AddItemButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 100)
                    .padding()
            }
        }
        .padding(.horizontal)
    }
}

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
struct BackgroundView: View
{
    var imageName: String
    
    var body: some View 
    {
        Image("StaffMenuViewBG")
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
                .padding(.horizontal, 30)
        }
    }
}

#Preview 
{
    StaffMenuView()
}
