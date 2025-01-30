//
//  MenuItemService.swift
//  CapstoneProject
//
//  Created by Kaleb on 10/11/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UIKit

class MenuItemService {
    
    // Function to get all documents in the "MenuItems" collection
    func fetchMenuItems(completion: @escaping ([MenuItem]) -> Void) {
        let db = Firestore.firestore()
        
        // Reference to the "MenuItems" collection
        db.collection("MenuItems").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])  // Return an empty array on error
            } else {
                var items: [MenuItem] = []
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    // Extract the fields from each document and create a MenuItem
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let price = data["price"] as? Double ?? 0.0
                    let imagePath = data["imagepath"] as? String ?? ""
                    let category = data["category"] as? String ?? ""
                    let isPopular = data["isPopular"] as? Bool ?? false
                    
                    //Test for AR View (A hardcoded path to an stl file
                    let ARModelPath = "shoe"
                    
                    let menuItem = MenuItem(id: document.documentID, title: title, description: description, price: price, imagePath: imagePath, category: category, isPopular: isPopular, ARModelPath: ARModelPath)
                    items.append(menuItem)
                }
                
                // Pass the items back to the view that called it
                completion(items)
            }
        }
    }
    
    
    
}

struct MenuItem: Identifiable {
    var id: String
    var title: String
    var description: String
    var price: Double
    var imagePath: String
    var category: String
    var isPopular: Bool
    var ARModelPath: String
    var quantity: Int   // Added quantity for CartManager
    
    // initializer with default values
    init(id: String = UUID().uuidString,
         title: String = "Item Name",
         description: String = "Enter description",
         price: Double = 0.0,
         imagePath: String = "defaultImage",
         category: String = "Enter Category",
         isPopular: Bool = false,
         ARModelPath: String = "AR Model Path",
         quantity: Int = 1) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.imagePath = imagePath
        self.category = category
        self.isPopular = isPopular
        self.ARModelPath = ARModelPath
        self.quantity = quantity
    }
}
