//
//  NavigationBar.swift
//  CapstoneProject
//
//  Created by Kaleb on 11/5/24.
//

import SwiftUI

struct NavigationBar: View {
    let buttons: [(destination: AnyView, offset: CGFloat)] = [
        (destination: AnyView(HomePageView()), offset: -6),
        (destination: AnyView(HomePageView()), offset: -3),
        (destination: AnyView(MenuView()), offset: 0),
        (destination: AnyView(StoreView()), offset: 5),
        (destination: AnyView(HomePageView()), offset: 10)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image for the bar
                Image("NavigationBar")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                
                HStack {
                    Spacer()
                    
                    //Defines all 5 rectangle buttons
                    ForEach(0..<buttons.count, id: \.self) { index in
                        NavigationLink(destination: buttons[index].destination) {
                            Rectangle()
                                .stroke(Color.clear, lineWidth: 2) // Black outline
                                .frame(width: 70, height: 52)
                                .offset(x: buttons[index].offset, y: -5)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}
#Preview {
    NavigationBar()
}
