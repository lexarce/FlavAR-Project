//
//  StaffHomePageView.swift
//  CapstoneProject
//
//  Created by kimi on 11/9/24.
//
// NOTE: This file only exists so we can easily see how the staff view would look like. The
//       HomePageView.swift will automatically check whether a user is an admin or not, and adjust
//       the UI.

import SwiftUI
import FirebaseAuth

struct StaffHomePageView: View {
    @State private var image: UIImage? = nil
    @State private var userName: String = "User"  // Default name if the user is not found
    @State private var isAdmin: Bool = false // Track if user is an admin or not
    
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
                        CustomerGalleryImageView(images: galleryImages, isAdmin: true)
                            .background(Color.black)
                            .cornerRadius(25)
                            .padding()
                        
                        // header for promo codes
                        DealsHeadline(isAdmin: true)
                        
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
            .onAppear {
                // Fetch the admin status when the view appears
                checkUserAdminStatus { (isAdminStatus, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    } else {
                        // Update the admin status on the main thread
                        DispatchQueue.main.async {
                            self.isAdmin = isAdminStatus ?? false
                        }
                    }
                }
            }
        }
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
