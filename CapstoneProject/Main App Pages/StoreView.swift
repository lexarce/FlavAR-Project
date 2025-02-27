//
//  StoreView.swift
//  CapstoneProject
//
//  Created by kimi on 11/22/24.
//

import SwiftUI
import MapKit

struct StoreView: View {
    @EnvironmentObject var navigationManager: NavigationManager //For navigating views
    
    // Define the location of the store using coordinates
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4255, longitude: -111.8587), // Store coordinates (Mesa, AZ)
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    // User tracking mode state
    @State private var userTrackingMode: MapUserTrackingMode = .follow // Use follow mode
    // Admin availability toggle state
    @State private var isAvailable: Bool = true // store ordering state
    @State private var isAdmin: Bool = true // set it to true temporarily

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Image
                BackgroundView(imageName: "LightRedBG")
                
                VStack(alignment: .leading, spacing: 1) {
                    Spacer()
                        .frame(height: 80)
                    
                    // Jin BBQ Logo
                    HStack {
                        Image("JinBBQTakeout")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 90)
                            .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    
                    // Line to separate
                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 1)
                        {
                            // Store address text
                            Text("Address")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.leading, 5)
                                .padding(.bottom, 10)
                                .padding(.top, 10)
                            
                            // Line to separate
                            Image("Line")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                            
                            Text("111 S Dobson Rd Ste 104, Mesa, AZ 85202")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .padding(.leading, 5)
                                .padding(.bottom, 10)
                            
                            // Add Map View showing the store location
                            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $userTrackingMode)
                                .frame(height: 250)
                                .cornerRadius(15)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                            
                            // Store hours text
                            Text("Store Hours")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.leading, 5)
                                .padding(.bottom, 10)
                                .padding(.top, 10)
                            
                            // Line to separate
                            Image("Line")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                            
                            // Store hours details
                            VStack(alignment: .leading, spacing: 1) {
                                HStack {
                                    Text("Friday")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("12 PM–12 AM")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 5)
                                
                                HStack {
                                    Text("Saturday")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("12 PM–12 AM")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 5)
                                
                                HStack {
                                    Text("Sunday")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("12 PM–10 PM")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 5)
                                
                                HStack {
                                    Text("Monday")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("5 PM–11 PM")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 5)
                                
                                HStack {
                                    Text("Tuesday")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("5 PM–11 PM")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 5)
                                
                                HStack {
                                    Text("Wednesday")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("5 PM–11 PM")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 5)
                                
                                HStack {
                                    Text("Thursday")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("5 PM–11 PM")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 5)
                                
                                // Add the Availability Toggles for Admin
                                if isAdmin { // Show the toggle section only for admins
                                    Text("Availability Toggles")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.leading, 5)
                                        .padding(.top, 20)
                                        .padding(.bottom, 10)

                                    // Line to separate
                                    Image("Line")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                    
                                    // Toggle for Availability
                                    Toggle(isOn: $isAvailable) {
                                        Text("Allow customers to order")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 20)
                                }
                            }
                        }
                    }
                    
                }
                .padding()
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
                    
                    //update current view
                    navigationManager.currentView = "StoreView"
                }
                .navigationBarBackButtonHidden(true)
                
                //Nav Bar
                VStack {
                    Spacer()
                    NavigationBar()
                }
                
            }//END OF ZSTACK
        }
    }
}

/*struct StoreHoursView: View {
    var body: some View {
        
    }
}*/

#Preview {
    StoreView()
        .environmentObject(NavigationManager.shared)
}
