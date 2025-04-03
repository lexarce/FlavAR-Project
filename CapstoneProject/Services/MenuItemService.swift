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

// Fetches menu items from Firebase Firestore

class MenuItemService {
    private let db = Firestore.firestore()

    func fetchMenuItems(completion: @escaping ([MenuItem]) -> Void) {
        db.collection("MenuItems").getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching menu items: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            let items = snapshot.documents.compactMap { doc -> MenuItem? in
                try? doc.data(as: MenuItem.self)
            }
            completion(items)
        }
    }
}
