//
//  MenuViewModel.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/27/25.
//

import Foundation
import FirebaseFirestore

// Fetches & stores menu items from Firebase
class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []

    private var db = Firestore.firestore()

    init() {
        fetchMenuItems()
    }

    func fetchMenuItems() {
        db.collection("MenuItems").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("❌ Error fetching menu items: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("❌ No documents found in MenuItems")
                return
            }

            DispatchQueue.main.async {
                self.menuItems = documents.compactMap { document in
                    do {
                        let menuItem = try document.data(as: MenuItem.self)
                        print("✅ Fetched item: \(menuItem.title), Price: \(menuItem.price), Image: \(menuItem.imagepath)")
                        return menuItem
                    } catch {
                        print("❌ Error decoding item: \(error.localizedDescription)")
                        return nil
                    }
                }
                print("✅ Total menu items fetched: \(self.menuItems.count)")
            }
        }
    }
}
