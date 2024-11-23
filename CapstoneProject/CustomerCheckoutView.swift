//
//  CustomerCheckoutView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 11/7/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct CustomerCheckoutView: View {
    @State private var selectedTime: Date? = nil // Pickup time
    @State private var asSoonAsPossible = true // Default to "As soon as possible"
    @State private var validTimeSlots: [Date] = [] // Dynamically generated time slots
    @State private var selectedTip: Double = 0.0 // Track tip amount
    @State private var customTip: String = "" // For custom tip input
    
    @State private var subtotal: Double = 25.00 // Example subtotal
    private var tax: Double {
        subtotal * 0.083 // 8.3% Mesa, AZ combined sales tax
    }
    private var total: Double {
        subtotal + tax + selectedTip
    }
    
    // Placeholder for now, need to add to Firebase
    private let restaurantHours: [String: (start: String, end: String, lastCall: String)] = [
        "Monday": ("17:00", "23:00", "22:00"),
        "Tuesday": ("17:00", "23:00", "22:00"),
        "Wednesday": ("17:00", "23:00", "22:00"),
        "Thursday": ("17:00", "23:00", "22:00"),
        "Friday": ("12:00", "24:00", "23:00"),
        "Saturday": ("12:00", "24:00", "23:00"),
        "Sunday": ("12:00", "22:00", "21:00")
    ]
    
    enum PaymentMethod: String, CaseIterable {
        case creditCard = "Credit Card"
        case paypal = "PayPal"
        case googlePay = "Google Pay"
        case applePay = "Apple Pay"
    }
    
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("PlainBG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    // Top bar with back button & cart button
                    HStack {
                        // Back button to navigate to CustomerMenuView
                        NavigationLink(destination: CustomerCartView()) {
                            Image("BackButton")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                        Spacer()
                        
                        // Exit button to navigate to HomePageView
                        NavigationLink(destination: HomePageView()) {
                            Image("ExitButton")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    Spacer(minLength: 1) // Adds space above Checkout title
                    
                    // Checkout Title
                    Text("CHECKOUT")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                
                ScrollView {
                    // Choose Time for Pickup Section
                    VStack(alignment: .leading, spacing: 15) {
                            Text("Choose Time for Pickup")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            VStack(spacing: 10) {
                                Button(action: {
                                    asSoonAsPossible = true
                                    selectedTime = validTimeSlots.first
                                }) {
                                    HStack {
                                        Image(systemName: asSoonAsPossible ? "largecircle.fill.circle" : "circle")
                                            .foregroundColor(asSoonAsPossible ? .yellow : .gray)
                                        Text("As Soon As Possible")
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Button(action: {
                                    asSoonAsPossible = false
                                    selectedTime = nil
                                }) {
                                    HStack {
                                        Image(systemName: !asSoonAsPossible ? "largecircle.fill.circle" : "circle")
                                            .foregroundColor(!asSoonAsPossible ? .yellow : .gray)
                                        Text("Select a Later Time")
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            
                            if !asSoonAsPossible {
                                Picker("Select Pickup Time", selection: $selectedTime) {
                                    ForEach(validTimeSlots, id: \.self) { time in
                                        Text(formatDate(time)).tag(time as Date?)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Payment Methods Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Payment Method")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            ForEach(PaymentMethod.allCases, id: \.self) { method in
                                Button(action: {
                                    selectedPaymentMethod = method
                                }) {
                                    HStack {
                                        Image(systemName: selectedPaymentMethod == method ? "largecircle.fill.circle" : "circle")
                                            .foregroundColor(selectedPaymentMethod == method ? .yellow : .gray)
                                        Text(method.rawValue)
                                            .foregroundColor(.white)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Cart Summary Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cart Summary")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("2 x Premium Bulgogi")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("$29.98")
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Text("1 x Japchae")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("$14.99")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Add Tip Section
                        VStack(alignment: .leading) {
                            Text("Add a Tip")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 10) {
                                ForEach([10, 15, 20], id: \.self) { percent in
                                    Button(action: {
                                        selectedTip = subtotal * Double(percent) / 100.0
                                        customTip = ""
                                    }) {
                                        Text("\(percent)%")
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(width: 70, height: 40)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(selectedTip == subtotal * Double(percent) / 100.0 ? Color("AppColor4") : Color.gray)
                                            )
                                    }
                                }
                                
                                Button(action: {
                                    // Show custom tip input
                                }) {
                                    Text("Custom")
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(width: 100, height: 40)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.gray)
                                        )
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Subtotal, Tax, and Total Section
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
                                Text("Tip")
                                    .foregroundColor(.white)
                                Spacer()
                                Text("$\(selectedTip, specifier: "%.2f")")
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
                        
                        // Place Order Button
                    NavigationLink(destination: OrderConfirmationView()) {
                            Text("PLACE ORDER >")
                                .bold()
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color("AppColor4"))
                                )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 80)
                        .offset(y: 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Helper Functions
    private func generateValidTimeSlots() {
        validTimeSlots = []
        let currentDay = getCurrentDay()
        
        guard let hours = restaurantHours[currentDay],
              let start = parseTime(hours.start),
              let lastCall = parseTime(hours.lastCall) else {
            return
        }
        
        var current = start
        while current <= lastCall {
            validTimeSlots.append(current)
            current = Calendar.current.date(byAdding: .minute, value: 30, to: current) ?? current
        }
    }
    
    private func getCurrentDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }
    
    private func parseTime(_ time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let date = formatter.date(from: time) else { return nil }
        return Calendar.current.date(
            bySettingHour: Calendar.current.component(.hour, from: date),
            minute: Calendar.current.component(.minute, from: date),
            second: 0, of: Date()
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Preview
struct CustomerCheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerCheckoutView()
    }
}

