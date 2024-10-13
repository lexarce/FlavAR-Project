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
                    
                    let menuItem = MenuItem(id: document.documentID, title: title, description: description, price: price, imagePath: imagePath)
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
}
