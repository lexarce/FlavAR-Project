//
//  CapstoneProjectApp.swift
//  CapstoneProject
//
//  Created by Kaleb on 9/23/24.
//

import SwiftUI
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

//This is where the program starts
@main
struct CapstoneProjectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
    }
    
    //The program will start in LoginView()
    var body: some Scene {
        WindowGroup {
            //Change this line to change where the simulator opens from.
            //It must be a view file
            
            LoginView()
            //CustomerMenuView()
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
