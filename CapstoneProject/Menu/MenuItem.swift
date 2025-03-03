//
//  MenuItem.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/27/25.
//  Edited by Kimberly Costes 2/26/25
//

import FirebaseFirestore

struct MenuItem: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let description: String
    let price: Double
    let imagepath: String
    let category: String
    var isPopular: Bool
    var ARModelPath: String? = nil
    var isAvailable: Bool = true
    var quantity: Int? = 1
    var customizations: [String]?
    var nutrition: Nutrition?

    // initializer
    init(id: String? = nil, title: String, description: String, price: Double, imagepath: String, category: String, isPopular: Bool, ARModelPath: String? = nil, isAvailable: Bool = true, quantity: Int = 1) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.imagepath = imagepath
        self.category = category
        self.isPopular = isPopular
        self.ARModelPath = ARModelPath
        self.isAvailable = isAvailable
        self.quantity = quantity
        self.customizations = nil
    }
}
