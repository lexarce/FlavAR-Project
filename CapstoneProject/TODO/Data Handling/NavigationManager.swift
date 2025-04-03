//
//  NavigationManager.swift
//  CapstoneProject
//
//  Created by Kaleb on 2/2/25.
//

import SwiftUI

//keeps track of current view. Accessible from any view.
//SEE BELOW ON HOW TO USE
class NavigationManager: ObservableObject {
    @Published var currentView: String = "HomePage"//default
    
    static let shared = NavigationManager() //Singleton Pattern :D WOW SO COOL
    
    private init() {}
}

/*
 Step 1: Add this line inside the struct but above the body
    @EnvironmentObject var navigationManager: NavigationManager
 
 Step 2: Add an environment object like this to the preview section so the preview doesnt crash
    #Preview {
        ViewName()
            .environmentObject(NavigationManager.shared)
    }
 
 Step 3: Update the view initially in a .onAppear {}, use the line to update the current view from anywhere
    .onAppear {
        navigationManager.currentView = "Name of View goes here"
    }
 */
