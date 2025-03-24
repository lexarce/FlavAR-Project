//
//  CapstoneProjectApp.swift
//  CapstoneProject
//
//  Created by Kaleb on 9/23/24.
//  Edited by Kimberly 2/28/25
//

import SwiftUI
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

//This is where the program starts
@main
struct CapstoneProjectApp: App {
    @StateObject var cartManager = CartManager.shared // changed CartManager to CartManager.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    //Object for keeping track of which view the app is in
    @StateObject private var navigationManager = NavigationManager.shared
    @StateObject var userManager = UserInfoManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    //The program will start in LoginView()
    var body: some Scene {
        WindowGroup {
            //Change this line to change where the simulator opens from.
            //It must be a view file
            
            //HomePageView()
            LoginView()
            //CustomerCheckoutView()
            //ContentView()
            //CustomerMenuView()
                .environmentObject(navigationManager)
                .environmentObject(userManager)
            
               // .environmentObject(cartManager)
                //.environmentObject(navigationManager)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Any additional setup after launching can be done here
        return true
    }

    // Other delegate methods can be added as needed
}
