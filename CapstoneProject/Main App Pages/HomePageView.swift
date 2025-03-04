//
//  HomePageView.swift
//  CapstoneProject
//
//  Created by kimi on 11/08/24.
//

// BROKEN

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UIKit

let storage = Storage.storage()



//A Placeholder for the HomePageView
struct HomePageView: View {
    @EnvironmentObject var navigationManager: NavigationManager //For navigating views
    @State private var image: UIImage? = nil
    @State private var userName: String = "User"  // Default name if the user is not found
    @State private var isAdmin: Bool = false // Track if user is an admin or not
    @EnvironmentObject var userManager: UserInfoManager
    
    let galleryImages: [String] = ["JinGalleryPic1", "JinGalleryPic2", "JinGalleryPic3"]

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(imageName: "Bright_Red_Gradient_BG")
                
                VStack {
                    Spacer(minLength: 90)
                    GreetUser(userName: $userName)

                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)

                    ScrollView {
                        VStack {
                            CustomerGalleryImageView(images: galleryImages, isAdmin: isAdmin)
                                .background(Color.black)
                                .cornerRadius(25)
                                .padding()

                            DealsHeadline(isAdmin: isAdmin)

                            Image("Line")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    Spacer()
                }
                .navigationBarBackButtonHidden(true)
                .padding(.top, 10)
                .onAppear {
                    //checking admin status
                    checkUserAdminStatus { (isAdminStatus, error) in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        } else {
                            DispatchQueue.main.async {
                                self.isAdmin = isAdminStatus ?? false
                            }
                        }
                    }
                    
                    //updating view
                    navigationManager.currentView = "HomePageView"
                    
                    //Get user info
                    userManager.fetchUserInfo()
                }
                .onReceive(userManager.$userInfo) { userInfo in
                    if let userInfo = userInfo {
                        print("User First Name: \(userInfo.firstName)")
                    } else {
                        print("User info is nil")
                    }
                }
                
                VStack {
                    Spacer()
                    NavigationBar()
                }
            }
        }
    }
}

// Header that greets the user
struct GreetUser: View {
    @Binding var userName: String

    var body: some View {
        Text("Hi \(userName)!")
            .font(.headline)
            .foregroundColor(.white)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)  // Add left padding
            .onAppear {
                // Fetch user name from Firebase when the view appears
                if let user = Auth.auth().currentUser {
                    userName = user.displayName ?? "User" // Set to displayName if available, otherwise fallback to "User"
                }
            }
    }
}

struct DealsHeadline: View {
    var isAdmin: Bool
    var body: some View {
        HStack {
            
            // header for promo codes
            Text("Deals of the Day!")
                .font(.title2)
                .foregroundColor(.white)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if isAdmin {
                // add button
                Button(action: {

                }) {
                    Image("AddItemCustomizationButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .padding(.trailing, 35)
                }
            }
        }
        .padding(.leading, 20)  // Add left padding
    }
}

// Gallery view for images
struct CustomerGalleryImageView: View {
    var images: [String]  // Array of image names or paths
    var isAdmin: Bool

    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(images, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .clipped()
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            
            // Description or sentence below the images
            Text("Indulge in the best of authentic Korean cuisine right here in Arizona. From sizzling BBQ to savory stews, experience the flavors that bring Korea to your table.")
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .multilineTextAlignment(.leading)
            
            if isAdmin {
                Button(action: {
                    // action to edit gallery images and text
                }) {
                    Image("DarkEditButton") // used to edit the image and upload a picture
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .padding(5)
                }
                .cornerRadius(18)
                .padding(.leading, 300)
                .padding(.bottom, 10)
            }
            else {
                HStack{
                    // "Order Now" button
                     NavigationLink(destination: MenuView()) {  // Link to the MenuView
                         Text("Order Now")
                             .font(.caption)
                             .padding(.vertical, 10)
                             .padding(.horizontal, 20)
                             .background(Color.orange)
                             .foregroundColor(.white)
                             .cornerRadius(10)
                     }
                     .padding(.leading, 1)
                     .padding(.bottom, 2)
                }
                .padding(.top, 2)
                .padding(.bottom, 15)
                .padding(.leading, -168)
            }

        }
    }
}


#Preview {
    HomePageView()
        .environmentObject(NavigationManager.shared)
}
 
