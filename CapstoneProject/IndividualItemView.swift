//
//  IndividualItemView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 10/23/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct IndividualItemView: View {
    var menuItem: MenuItem  // Pass the MenuItem
    
    @State private var downloadedImage: UIImage? = nil  // Holds the downloaded image
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>  // Used to dismiss the view
    
    var body: some View {
        ZStack {
            Image("CustomerOrderMenuBG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Top bar with back button and cart button
                HStack {
                    // Back button to dismiss the view
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()  // Dismiss the view to go back
                    }) {
                        Image("BackButton")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                    Spacer()
                    
                    // Cart button (implementing later)
                    Button(action: {
                        // Action for cart button
                    }) {
                        Image("CartButton")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                }
                .padding(.horizontal)
                
                Spacer()

                // Display the selected item's details
                VStack {
                    // Item Image: Load image from Firebase
                    if let image = downloadedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 200)
                            .cornerRadius(20)
                    } else {
                        // Placeholder image while loading
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 300, height: 200)
                            .cornerRadius(20)
                    }
                    
                    // Item Title
                    Text(menuItem.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    // Item Description
                    Text(menuItem.description)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                    
                    // Item Price
                    Text("$\(menuItem.price, specifier: "%.2f")")
                        .font(.title)
                        .foregroundColor(.yellow)
                        .padding(.bottom)
                }
                
                Spacer()

                // Add to Cart button
                NavigationLink(destination: CustomerCartView()) {
                    Text("ADD TO CART")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color("AppColor4"))
                        )
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .offset(y: -100)
                .shadow(radius: 10)
            }
        }
        .onAppear {
            loadImage()  // Download the image when the view appears
        }
    }

    // Function to download the image from Firebase Storage
    func loadImage() {
        let imageDownloader = ImageDownloader()
        imageDownloader.downloadImage(from: menuItem.imagePath) { uiImage in
            DispatchQueue.main.async {
                self.downloadedImage = uiImage  // Update the image state when loaded
            }
        }
    }
}

// Preview for IndividualItemView
struct IndividualItemView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample MenuItem to use for preview
        let sampleMenuItem = MenuItem(
            id: "1",
            title: "Premium Beef Bulgogi Box",
            description: "Delicious beef bulgogi served with rice, vegetables, and sauce.",
            price: 14.99,
            imagePath: "PremiumBulgogiBox"  // Replace with a valid image name from your assets
        )
        
        // Pass the sampleMenuItem to IndividualItemView
        return IndividualItemView(menuItem: sampleMenuItem)
            .previewLayout(.sizeThatFits)
            .background(Color.black)
    }
}
