//
//  CustomizationsViewModel.swift
//  CapstoneProject
//
//  Created by kimi on 3/3/25.
//

import SwiftUI
import FirebaseFirestore

class CustomizationViewModel: ObservableObject {
    @Published var customizations: [CustomizationCategory] = []
    
    private let db = Firestore.firestore()
    
    // get customizations from firebase based on menu item id
    func fetchCustomizations(for menuItemID: String) {
        db.collection("MenuItems").document(menuItemID)
            .collection("customizations").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching customizations: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No customizations found.")
                    return
                }

                do {
                    self.customizations = try documents.compactMap { doc in
                        return try doc.data(as: CustomizationCategory.self)
                    }
                    print(" LOADED \(self.customizations.count) customization categories")
                } catch {
                    print(" ERROR decoding customizations: \(error)")
                }
            }
    }
    
    // toggle checkmark-based customization
    func toggleCheckmark(categoryIndex: Int, optionIndex: Int) {
        let isSelected = (customizations[categoryIndex].options[optionIndex].currentQuantity ?? 0) > 0
        customizations[categoryIndex].options[optionIndex].currentQuantity = isSelected ? 0 : 1
        objectWillChange.send()
    }
    
    // increase quantity-based customization
    func increaseQuantity(categoryIndex: Int, optionIndex: Int) {
        let maxQty = customizations[categoryIndex].options[optionIndex].maxQuantity ?? 1
        if (customizations[categoryIndex].options[optionIndex].currentQuantity ?? 0) < maxQty {
            customizations[categoryIndex].options[optionIndex].currentQuantity? += 1
            objectWillChange.send()
        }
    }
    
    // decrease quantity-based customization
    func decreaseQuantity(categoryIndex: Int, optionIndex: Int) {
        if (customizations[categoryIndex].options[optionIndex].currentQuantity ?? 0) > 0 {
            customizations[categoryIndex].options[optionIndex].currentQuantity? -= 1
            objectWillChange.send()
        }
    }
    
    // save selected customizations to Firestore
    func saveCustomizations(for menuItemID: String) {
        let customizationsData = customizations.map { try? Firestore.Encoder().encode($0) }
        
        let ref = db.collection("MenuItems").document(menuItemID)
        ref.setData(["customizations": customizationsData], merge: true) { error in
            if let error = error {
                print("ERROR saving customizations: \(error.localizedDescription)")
            } else {
                print("SUCCESS Customizations saved successfully!")
            }
        }
    }
}
