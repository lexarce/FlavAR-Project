//
//  Customizations.swift
//  CapstoneProject
//
//  Created by kimi on 3/3/25.
//

import FirebaseFirestore

struct CustomizationCategory: Codable, Identifiable {
    var categoryName: String
    var isRequired: Bool = false
    var options: [CustomizationOption] = []
    
    var id: String { categoryName }
    
}

enum SelectionType: String, Codable {
    case checkmark 
    case quantity
}

struct CustomizationOption: Codable, Identifiable {
    var name: String
    var additionalCost: Double? = 0.0
    var selectionType: SelectionType
    var maxQuantity: Int? = 1
    var currentQuantity: Int? = 0
    
    var id: String { name }
}

