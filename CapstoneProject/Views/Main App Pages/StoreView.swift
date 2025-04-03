//
//  StoreView.swift
//  CapstoneProject
//
//  Created by kimi on 11/22/24.
//

import SwiftUI
import MapKit
import FirebaseAuth

struct StoreView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userSessionViewModel: UserSessionViewModel
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.4255, longitude: -111.8587),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var isAvailable: Bool = true // store ordering toggle

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(imageName: "LightRedBG")
                
                VStack(alignment: .leading, spacing: 1) {
                    Spacer().frame(height: 80)

                    // Logo
                    HStack {
                        Image("WhiteJinBBQLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 90)
                            .padding(.top, -50)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    
                    Image("Line")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Address")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding([.leading, .bottom, .top], 10)

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

                            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $userTrackingMode)
                                .frame(height: 250)
                                .cornerRadius(15)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)

                            Text("Store Hours")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding([.leading, .bottom, .top], 10)

                            Image("Line")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)

                            StoreHoursSection()

                            // ✅ Only show this if admin
                            if userSessionViewModel.isAdmin {
                                Text("Availability Toggles")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding([.leading, .top], 10)

                                Image("Line")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)

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
                .padding()
                .onAppear {
                    navigationManager.currentView = "StoreView"
                    userSessionViewModel.checkAdminStatus()
                }
                .navigationBarBackButtonHidden(true)

                VStack {
                    Spacer()
                    NavigationBar()
                }
            }
        }
    }
}

struct StoreHoursSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            StoreHoursRow(day: "Friday", hours: "12 PM–12 AM")
            StoreHoursRow(day: "Saturday", hours: "12 PM–12 AM")
            StoreHoursRow(day: "Sunday", hours: "12 PM–10 PM")
            StoreHoursRow(day: "Monday", hours: "5 PM–11 PM")
            StoreHoursRow(day: "Tuesday", hours: "5 PM–11 PM")
            StoreHoursRow(day: "Wednesday", hours: "5 PM–11 PM")
            StoreHoursRow(day: "Thursday", hours: "5 PM–11 PM")
        }
    }
}

struct StoreHoursRow: View {
    let day: String
    let hours: String

    var body: some View {
        HStack {
            Text(day)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Text(hours)
                .font(.system(size: 18))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 5)
    }
}

#Preview {
    StoreView()
        .environmentObject(NavigationManager.shared)
        .environmentObject(UserSessionViewModel())
}
