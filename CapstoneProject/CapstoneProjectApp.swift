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

@main
struct CapstoneProjectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
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
