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
                            .stroke(Color.black, lineWidth: 2) // Black outline
                            .frame(width: 40, height: 40) // Square size
                    }
                    
                    Spacer()
                    
                    // Button: Order Page
                    NavigationLink(destination: HomePageView()) {
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2) // Black outline
                            .frame(width: 40, height: 40)
                    }
                    
                    Spacer()
                    
                    // Button: Menu Page
                    NavigationLink(destination: CustomerMenuView()) {
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2) // Black outline
                            .frame(width: 40, height: 40)
                    }
                    
                    Spacer()
                    
                    // Button: Store Page
                    NavigationLink(destination: HomePageView()) {
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2) // Black outline
                            .frame(width: 40, height: 40)
                    }
                    
                    Spacer()
                    
                    // Button: Profile Page
                    NavigationLink(destination: HomePageView()) {
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2) // Black outline
                            .frame(width: 40, height: 40)
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
