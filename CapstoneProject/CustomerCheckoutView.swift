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
    
    // Need to connect this subtotal to the Cart to update dynamically
    private var subtotal: Double = 25.00 // Example subtotal
    private var tax: Double {
        subtotal * 0.083 // 8.3% Mesa, AZ combined sales tax
    }
    private var total: Double {
        subtotal + tax
    }
    
    /* Static restaurant hours for now
     Need to add the restaurant hours & last call times to Firebase
     This should update dynamically depending on the current date and time */
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
                
                VStack(spacing: 20) {
                    // Checkout Title
                    Text("Checkout")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    
                    // Choose Time for Pickup
                    VStack(alignment: .leading) {
                        Text("Choose Time for Pickup")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        // Radio Buttons
                        HStack {
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
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        
                        HStack {
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
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        
                        if !asSoonAsPossible {
                            // Dropdown for Valid Time Slots
                            Picker("Select Pickup Time", selection: $selectedTime) {
                                ForEach(validTimeSlots, id: \.self) { time in
                                    Text(formatDate(time)).tag(time as Date?)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .labelsHidden()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        generateValidTimeSlots()
                    }
                    
                    // Payment Methods Section
                    VStack(alignment: .leading) {
                        Text("Payment Method")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(PaymentMethod.allCases, id: \.self) { method in
                            HStack {
                                Image(systemName: selectedPaymentMethod == method ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(selectedPaymentMethod == method ? .yellow : .gray)
                                    .onTapGesture {
                                        selectedPaymentMethod = method
                                    }
                                
                                Text(method.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                    }
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
                    
                    Spacer()
                    
                    // Place Order Button
                    Button {
                        // Handle place order action
                    } label: {
                        NavigationLink(destination: OrderConfirmationView()) {
                            Text("PLACE ORDER >")
                                .bold()
                                .foregroundStyle(Color("AppColor1"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color("AppColor3"), Color.white, Color("AppColor3")]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .offset(y: -60)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Helper Functions
    
    /// Generate valid time slots for the current day
    private func generateValidTimeSlots() {
        validTimeSlots = [] // Clear existing slots
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
    
    /// Get the current day of the week
    private func getCurrentDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }
    
    /// Parse a time string (e.g., "17:00") into a Date object
    private func parseTime(_ time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let date = formatter.date(from: time) else { return nil }
        
        // Combine with today's date
        return Calendar.current.date(
            bySettingHour: Calendar.current.component(.hour, from: date),
            minute: Calendar.current.component(.minute, from: date),
            second: 0,
            of: Date()
        )
    }
    
    /// Format a Date into a readable time string
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
