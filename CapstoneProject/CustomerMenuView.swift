//
//  CustomerMenuView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 10/7/24.
//

import SwiftUI

struct CustomerMenuView: View {
    
    var body: some View
    {
        ZStack
        {
            Image("CustomerOrderMenuBG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack
            {
                ScrollView
                {
                    VStack(alignment: .leading, spacing: 10)
                    {
                        Spacer().frame(height: 150)
                        
                        Text("Premium Jin's Box")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        MenuItemView(
                            imageName: "PremiumBulgogiBox",
                            title: "Premium Beef Bulgogi Box",
                            description: "Beef bulgogi, white rice, kimchi, salad, and Korean traditional soybean paste soup.",
                            price: "$14.99"
                        )
                        
                        MenuItemView(
                            imageName: "PremiumSpicyPorkBox",
                            title: "Premium Spicy Pork Box",
                            description: "Spicy pork bulgogi, white rice, kimchi, salad, and Korean traditional soybean paste soup.",
                            price: "$14.99"
                        )
                        
                        MenuItemView(
                            imageName: "PremiumPorkBellyBox",
                            title: "Premium Pork Belly Box",
                            description: "Stir-fried pork belly with white rice, kimchi, salad, and Korean traditional soybean paste soup.",
                            price: "$14.99"
                        )
                        
                        MenuItemView(
                            imageName: "PremiumJapchaeBox",
                            title: "Premium Japchae Box",
                            description: "Stir-fried glass noodles with beef, white rice, kimchi, salad, and Korean traditional soybean paste soup.",
                            price: "$14.99"
                        )
                    }
                    .padding()
                }
                
                Spacer()
                
                // Navigation Bar
                Image("NavBar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
                
                Spacer().frame(height: 40)
            }
        }
    }
}

// Separate view for each  menu item
struct MenuItemView: View {
    
    var imageName: String
    var title: String
    var description: String
    var price: String
    
    var body: some View
    {
        HStack
        {
            Image(imageName)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 5)
            {
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
    }
}

// Preview
struct CustomerMenuView_Previews: PreviewProvider {
    
    static var previews: some View
    {
        CustomerMenuView()
    }
}
