//
//  MenuItem.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/27/25.
//

import Foundation
import FirebaseFirestore

struct MenuItem: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let description: String
    let price: Double
    let imagepath: String
    //let category: String
    //let isPopular: Bool
    var ARModelPath: String? = nil  // Default
    var isAvailable: Bool = true    // Default to true if not specified
    var quantity: Int = 1   // Default quantity
}
