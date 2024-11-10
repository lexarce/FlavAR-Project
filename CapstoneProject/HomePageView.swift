//
//  HomePageView.swift
//  CapstoneProject
//
//  Created by kimi on 11/08/24.
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
    @State private var userName: String = "User"  // Default name if the user is not found
    
    // Dynamic array for images
    let galleryImages: [String] = ["JinGalleryPic1", "JinGalleryPic2", "JinGalleryPic3"]  // Updated with your image names

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                BackgroundView(imageName: "Bright_Red_Gradient_BG")
                
                VStack {
                    
                    Spacer(minLength: 90)
                    // Fetch the user's name from Firebase Authentication when the view appears
                    GreetUser(userName: $userName)
                    
                    // Line to separate
                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                    
                    ScrollView {
                        VStack {
                            // Scrollable image gallery
                            CustomerGalleryImageView(images: galleryImages)
                                .background(Color.black)
                                .cornerRadius(25)
                                .padding()
                            
                            // header for promo codes
                            Text("Deals of the Day!")
                                .font(.title2)
                                .foregroundColor(.white)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)  // Add left padding
                            
                            // Line to separate
                            Image("Line")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
    }
}

// Gallery view for images
struct CustomerGalleryImageView: View {
    var images: [String]  // Array of image names or paths

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
            
            HStack{
                // "Order Now" button
                 NavigationLink(destination: CustomerMenuView()) {  // Link to the MenuView
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


#Preview {
    HomePageView()
}
