//
//  MenuViewModel.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/27/25.
//  Updated by Kimberly on 4/3/25
//

import Foundation
import FirebaseFirestore

// ViewModel that fetches, filters, and stores menu items from Firestore

class MenuViewModel: ObservableObject {
    @Published var allMenuItems: [MenuItem] = []
    @Published var filteredMenuItems: [MenuItem] = []
    @Published var selectedCategory: String? = nil
    @Published var isFilteringPopular: Bool = false

    private var db = Firestore.firestore()

    init() {
        fetchMenuItems()
    }

    func fetchMenuItems() {
        db.collection("MenuItems").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching menu items: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents found in MenuItems")
                return
            }

            DispatchQueue.main.async {
                self.allMenuItems = documents.compactMap { document in
                    try? document.data(as: MenuItem.self)
                }
                self.filteredMenuItems = self.allMenuItems
            }
        }
    }

    func filterByCategory(_ category: String) {
        if selectedCategory == category {
            selectedCategory = nil
            applyFilters()
        } else {
            selectedCategory = category
            isFilteringPopular = false
            applyFilters()
        }
    }

    func filterByPopular() {
        isFilteringPopular.toggle()
        if isFilteringPopular {
            selectedCategory = nil
        }
        applyFilters()
    }

    func applyFilters() {
        filteredMenuItems = allMenuItems.filter { item in
            let matchesCategory = selectedCategory == nil || item.category == selectedCategory
            let matchesPopular = !isFilteringPopular || item.isPopular
            return matchesCategory && matchesPopular
        }
    }

    func searchItems(_ query: String) {
        filteredMenuItems = allMenuItems.filter { item in
            item.title.lowercased().contains(query.lowercased())
        }
    }

    func resetFilters() {
        selectedCategory = nil
        isFilteringPopular = false
        filteredMenuItems = allMenuItems
    }
}
