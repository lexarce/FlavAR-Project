//
//  Customizations.swift
//  CapstoneProject
//
//  Created by kimi on 3/3/25.
//

import FirebaseFirestore

struct CustomizationCategory: Codable, Identifiable {
    var categoryName: String // "Replace Rice With"
    var isRequired: Bool = false// true if a choice is mandatory
    var options: [CustomizationOption] = []// list of available options
    
    var id: String { categoryName }
    
}

enum SelectionType: String, Codable {
    case checkmark // for options like "No Onions"
    case quantity  // for options like "Extra sauce" (limit 3)
}

struct CustomizationOption: Codable, Identifiable {
    var name: String // "Lettuce", "Rice"
    var additionalCost: Double? = 0.0// 0.50
    var selectionType: SelectionType // checkmark or quantity
    var maxQuantity: Int? = 1// only applies for quantity-based options
    var currentQuantity: Int? = 0// defaults to 0 (for UI updates)
    
    var id: String { name } //identifier
}

