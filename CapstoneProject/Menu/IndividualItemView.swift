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

// Shows pop-up details when an item is tapped

struct IndividualItemView: View {
    var menuItem: MenuItem
    @State private var isARViewPresented: Bool = false
    @State private var downloadedImage: UIImage? = nil
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Image("CustomerOrderMenuBG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("BackButton")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                    Spacer()
                    NavigationLink(destination: CustomerCartView().environmentObject(cartManager)) {
                        Image("CartButton")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack {
                    if let image = downloadedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 200)
                            .cornerRadius(20)
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 300, height: 200)
                            .cornerRadius(20)
                    }
                    
                    Button(action: {
                        isARViewPresented.toggle()
                    }) {
                        Text("View in AR")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("AppColor4"))
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $isARViewPresented) {
                        SheetView(isPresented: $isARViewPresented, modelName: menuItem.ARModelPath ?? "shoe")
                    }
                    
                    Text(menuItem.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(menuItem.description)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                    
                    Text("$\(menuItem.price, specifier: "%.2f")")
                        .font(.title)
                        .foregroundColor(.yellow)
                        .padding()
                }
                
                Divider()
                
                Button(action: {
                    cartManager.addToCart(menuItem)
                }) {
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
                .padding(.horizontal, 20)
                .shadow(radius: 10)
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    func loadImage() {
        let imageDownloader = ImageDownloader()
        imageDownloader.downloadImage(from: menuItem.imagepath) { uiImage in
            DispatchQueue.main.async {
                self.downloadedImage = uiImage
            }
        }
    }
}

struct IndividualItemView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMenuItem = MenuItem(
            id: "1",
            title: "Premium Beef Bulgogi Box",
            description: "Delicious beef bulgogi served with rice, vegetables, and sauce.",
            price: 14.99,
            imagepath: "PremiumBulgogiBox",
            category: "Jin's Box",
            isPopular: true, 
            isAvailable: true
        )

        
        return IndividualItemView(menuItem: sampleMenuItem)
            .environmentObject(CartManager.shared) // changed CartManager() to CartManager.shared - EDITED BY KIMI
            .previewLayout(.sizeThatFits)
            .background(Color.black)
    }
}
