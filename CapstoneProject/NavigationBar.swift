//
//  NavigationBar.swift
//  CapstoneProject
//
//  Created by Kaleb on 11/5/24.
//

import SwiftUI

struct NavigationBar: View {
    var body: some View {
        NavigationStack {
            
        VStack {
            Spacer() // Pushes the bar to the bottom of the screen
            
            
            ZStack {
                // Background image for the bar
                Image("NavigationBar")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80) // Adjust the height to match your design
                
                HStack {
                    Spacer()
                    
                    // Button: Home Page
                    NavigationLink(destination: HomePageView()) {
                        Rectangle()
                            .stroke(Color.clear, lineWidth: 2) // Black outline
                            .frame(width: 70, height: 52) // Square size
                            .offset(x: -6, y:  -5)
                    }
                    
                    Spacer()
                    
                    // Button: Order Page
                    NavigationLink(destination: HomePageView()) {
                        Rectangle()
                            .stroke(Color.clear, lineWidth: 2) // Black outline
                            .frame(width: 70, height: 52)
                            .offset(x: -3, y:  -5)
                    }
                    
                    Spacer()
                    
                    // Button: Menu Page
                    NavigationLink(destination: CustomerMenuView()) {
                        Rectangle()
                            .stroke(Color.clear, lineWidth: 2) // Black outline
                            .frame(width: 70, height: 52)
                            .offset(x: 0, y:  -5)
                    }
                    
                    Spacer()
                    
                    // Button: Store Page
                    NavigationLink(destination: HomePageView()) {
                        Rectangle()
                            .stroke(Color.clear, lineWidth: 2) // Black outline
                            .frame(width: 70, height: 52)
                            .offset(x: 5, y:  -5)
                    }
                    
                    Spacer()
                    
                    // Button: Profile Page
                    NavigationLink(destination: HomePageView()) {
                        Rectangle()
                            .stroke(Color.clear, lineWidth: 2) // Black outline
                            .frame(width: 70, height: 52)
                            .offset(x: 10, y:  -5)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16) // Horizontal padding within the bar
            }
            .padding(.bottom, 16) // Padding at the bottom to prevent cut-off
        }
        .edgesIgnoringSafeArea(.bottom) // Ensure it goes to the edge of the screen
    }
    }
}
#Preview {
    NavigationBar()
}


//Put this code at the end of a VStack to create the bar on that view

//.overlay(
//    NavigationBar()
//        .frame(maxWidth: .infinity) // Ensures the bar stretches across the full width
//        .padding(.bottom, 35)
//        , alignment: .bottom // Positions the navigation bar at the bottom of the screen
//    )
//    .edgesIgnoringSafeArea(.bottom)
