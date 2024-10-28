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
                    
                    // search bar for items
                    SearchBar(searchText: $searchText)
                        . padding(.vertical,10)
                    
                    // line to separate
                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                    
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
                    // TODO: center
                    HStack(spacing: 10) {
                        CategoryItemView(imageName: "PremiumBoxesIcon", categoryName: "Premium Jin's Box")
                        CategoryItemView(imageName: "KoreanFoodIcon", categoryName: "Korean Food")
                        CategoryItemView(imageName: "PopularIcon", categoryName: "Popular")
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // center the hstack
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    // line to separate
                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                    
                    // button for adding an item
                    ButtonGroupView()
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                    
                    MenuItemList()
                    
                    
                }
                .padding()
                
                
            }
        }
    }
}

// add item button
struct ButtonGroupView: View
{
    var body: some View
    {
        HStack(spacing: 20)
        {
            Spacer() // push button to the right

            Button(action: {
                // write action here
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

struct MenuItemList: View {
    var body: some View {
        // ------- Categories -----------
        // header
        // TODO: change font
        Text("Popular")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white)
            .padding(.leading, 5)
            .padding(.bottom, 10)
            .padding(.top, 10)
        
        // line to separate
        Image("Line")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
        
        Text("Premium Jin's Box")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white)
            .padding(.leading, 5)
            .padding(.bottom, 10)
            .padding(.top, 10)
        
        // line to separate
        Image("Line")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
        
        Text("Korean Food")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white)
            .padding(.leading, 5)
            .padding(.bottom, 10)
            .padding(.top, 10)
        
        // line to separate
        Image("Line")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
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
                .padding(.horizontal, 10)
        }
    }
}

#Preview
{
    StaffMenuView()
}

