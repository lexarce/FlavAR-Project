//
//  NavigationBar.swift
//  CapstoneProject
//
//  Created by Kaleb on 11/5/24.
//

import SwiftUI

struct NavigationBar: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    let buttons: [(destination: AnyView, viewID: String, offset: CGFloat)] = [
        (destination: AnyView(HomePageView()), viewID: "HomePageView", offset: -6),
        (destination: AnyView(HomePageView()), viewID: "HomePageView", offset: -3),//change to some order view
        (destination: AnyView(MenuView()), viewID: "MenuView", offset: 0),
        (destination: AnyView(StoreView()), viewID: "StoreView", offset: 5),
        (destination: AnyView(HomePageView()), viewID: "HomePageView", offset: 10)//change to profileview
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
                        // check if current view is the same as destination
                        if buttons[index].viewID != navigationManager.currentView {
                            NavigationLink(destination: buttons[index].destination) {
                                Rectangle()
                                    .stroke(Color.clear, lineWidth: 2)
                                    .frame(width: 70, height: 52)
                                    .offset(x: buttons[index].offset, y: -5)
                                    .onTapGesture {
                                        //update view
                                        navigationManager.currentView = buttons[index].viewID
                                    }
                                }
                        } else {
                            //dummy button if already on destination view
                            Rectangle()
                                .stroke(Color.clear, lineWidth: 2)
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
        .environmentObject(NavigationManager.shared)
}
