//
//  StaffHomePageView.swift
//  CapstoneProject
//
//  Created by kimi on 11/9/24.
//

import SwiftUI
import FirebaseAuth

struct StaffHomePageView: View {
    @State private var image: UIImage? = nil
    @State private var userName: String = "User"  // Default name if the user is not found
    
    // Dynamic array for images
    let galleryImages: [String] = ["JinGalleryPic1", "JinGalleryPic2", "JinGalleryPic3"]  // Updated with your image names

    var body: some View {
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
                
                ScrollView{
                    VStack {
                        // Scrollable image gallery
                        GalleryImageView(images: galleryImages)
                            .background(Color.black)
                            .cornerRadius(25)
                            .padding()
                        
                        // header for promo codes
                        DealsHeadline()
                        
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

// Header that greets the user
struct GreetUser: View {
    @Binding var userName: String

    var body: some View {
        Text("Hi \(userName)!")
            .font(.largeTitle)
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
    
    var body: some View {
        HStack {
            
            // header for promo codes
            Text("Deals of the Day!")
                .font(.title2)
                .foregroundColor(.white)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
        .padding(.leading, 20)  // Add left padding
    }
}

// Gallery view for images
struct GalleryImageView: View {
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
    }
}



#Preview {
    StaffHomePageView()
}
