//
//  Customizations.swift
//  CapstoneProject
//
//  Created by kimi on 3/3/25.
//

import FirebaseFirestore

enum SelectionType: String, Codable {
    case checkmark // For options like "No Onions"
    case quantity  // For options like "Extra sauce" (limit 3)
}

struct CustomizationOption: Codable {
    var name: String // e.g., "Lettuce", "Rice"
    var additionalCost: Double? // e.g., 0.50
    var selectionType: SelectionType // checkmark or quantity
    var maxQuantity: Int? // Only applies for quantity-based options
    var currentQuantity: Int? // Defaults to 0 (for UI updates)
}

struct CustomizationCategory: Codable {
    var categoryName: String // e.g., "Replace Rice With"
    var isRequired: Bool // e.g., true if a choice is mandatory
    var options: [CustomizationOption] // List of available options
}
