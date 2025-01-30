//
//  CustomerCartView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 11/7/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct CustomerCartView: View {
    @EnvironmentObject var cartManager: CartManager
    
    private var subtotal: Double {
        cartManager.cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    private var tax: Double {
        subtotal * 0.1 // Example 10% tax
    }
    
    private var total: Double {
        subtotal + tax
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("PlainBG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        NavigationLink(destination: CustomerMenuView().environmentObject(cartManager)) {
                            Image("BackButton")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                        Spacer()
                        
                        NavigationLink(destination: HomePageView().environmentObject(cartManager)) {
                            Image("ExitButton")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    
                    Text("CART")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(cartManager.cartItems) { item in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        if let image = UIImage(named: item.imagePath) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(8)
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray)
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(8)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(item.title)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            
                                            Text("$\(item.price, specifier: "%.2f")")
                                                .font(.subheadline)
                                                .foregroundColor(.yellow)
                                        }
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 10) {
                                            Button(action: {
                                                cartManager.removeFromCart(item)
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .foregroundColor(.yellow)
                                            }
                                            
                                            Text("\(item.quantity)")
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                            
                                            Button(action: {
                                                cartManager.addToCart(item)
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                    }
                                    Divider()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top, 5)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Subtotal")
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(subtotal, specifier: "%.2f")")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Text("Tax")
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(tax, specifier: "%.2f")")
                                .foregroundColor(.white)
                        }
                        HStack {
                            Text("Total")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(total, specifier: "%.2f")")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    NavigationLink(destination: CustomerCheckoutView().environmentObject(cartManager)) {
                        Text("CHECK OUT")
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
                    .padding(.bottom, 10)
                    
                    NavigationBar()
                    Spacer().frame(height: 40)
                }
            }
        }
    }
}

struct CustomerCartView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerCartView()
            .environmentObject(CartManager())
    }
}
