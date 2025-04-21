//
//  HomePageView.swift
//  CapstoneProject
//
//  Created by kimi on 11/08/24.
//
import SwiftUI
import FirebaseStorage
import FirebaseAuth

let storage = Storage.storage()

struct HomePageView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSessionViewModel: UserSessionViewModel

    @State private var image: UIImage? = nil
    @State private var userName: String = "User"
    @State private var isAdmin: Bool = false

    let galleryImages: [String] = ["JinGalleryPic1", "JinGalleryPic2", "JinGalleryPic3"]

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(imageName: "Bright_Red_Gradient_BG")

                VStack {
                    Spacer(minLength: 90)

                    // Greet the User
                    Text("Hi \(userSessionViewModel.userInfo?.firstName ?? "User")!")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)

                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)

                    ScrollView {
                        VStack {
                            CustomerGalleryImageView(
                                images: galleryImages,
                                isAdmin: userSessionViewModel.isAdmin
                            )
                            .background(Color.black)
                            .cornerRadius(25)
                            .padding()

                            DealsHeadline(isAdmin: userSessionViewModel.isAdmin)

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
                    navigationManager.currentView = "HomePageView"
                    userSessionViewModel.fetchUserInfo()
                    userSessionViewModel.checkAdminStatus()
                }

                VStack {
                    Spacer()
                    NavigationBar()
                }
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
        .environmentObject(UserSessionViewModel())
        .environmentObject(OrderViewModel())
        .environmentObject(NavigationManager.shared)
}

