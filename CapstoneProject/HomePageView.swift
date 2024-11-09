//
//  HomePageView.swift
//  CapstoneProject
//
//  Created by Kaleb on 9/23/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UIKit

let storage = Storage.storage()



//A Placeholder for the HomePageView
struct HomePageView: View {
    @State private var image: UIImage? = nil
    
    var body: some View {
        Text("Home Page View")
        
    }
}


#Preview {
    HomePageView()
}
