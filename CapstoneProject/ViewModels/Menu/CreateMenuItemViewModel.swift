//
//  CreateMenuItemViewModel.swift
//  CapstoneProject
//
//  Created by kimi on 4/3/25.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

@MainActor
class CreateMenuItemViewModel: ObservableObject {
    // Fields bound to the view
    @Published var title: String
    @Published var description: String
    @Published var price: String
    @Published var isAvailable: Bool
    @Published var isPopular: Bool
    @Published var category: String
    @Published var selectedImage: UIImage?
    @Published var imageURL: String?
    @Published var customizations: [CustomizationCategory] = []
    
    @Published var showSuccessMessage = false
    @Published var errorMessage: String?
    @Published var isUploading = false // loading state

    private let db = Firestore.firestore()
    private let menuItem: MenuItem
    private let imageFolder: String

    init(
        menuItem: MenuItem = MenuItem(title: "", description: "", price: 0.0, imagepath: "", category: "", isPopular: false),
        imageFolder: String = "menu_images"
    ) {
        self.menuItem = menuItem
        self.imageFolder = imageFolder
        self.title = menuItem.title
        self.description = menuItem.description
        self.price = String(format: "%.2f", menuItem.price)
        self.isAvailable = menuItem.isAvailable
        self.isPopular = menuItem.isPopular
        self.category = menuItem.category
        self.selectedImage = nil
        self.imageURL = menuItem.imagepath
    }

    // Save menu item
    func save() {
        errorMessage = nil
        showSuccessMessage = false

        guard validateFields() else { return }

        let menuItemRef = db.collection("MenuItems").document(menuItem.id ?? UUID().uuidString)
        isUploading = true

        if let image = selectedImage, let data = image.jpegData(compressionQuality: 0.8) {
            uploadImage(data, to: imageFolder) { [weak self] url in
                self?.imageURL = url
                self?.saveData(to: menuItemRef)
            }
        } else {
            saveData(to: menuItemRef)
        }
    }

    private func validateFields() -> Bool {
        if title.isEmpty || description.isEmpty || price.isEmpty || category.isEmpty {
            errorMessage = "Please fill out all required fields."
            return false
        }
        guard Double(price) != nil else {
            errorMessage = "Price must be a valid number."
            return false
        }
        return true
    }

    private func uploadImage(_ data: Data, to folder: String, completion: @escaping (String?) -> Void) {
        let ref = Storage.storage().reference().child("\(folder)/\(UUID().uuidString).jpg")
        ref.putData(data, metadata: nil) { _, error in
            if let error = error {
                print("Image upload error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            ref.downloadURL { url, _ in
                completion(url?.absoluteString)
            }
        }
    }

    private func saveData(to ref: DocumentReference) {
        guard let priceValue = Double(price) else {
            errorMessage = "Price must be a valid number."
            isUploading = false
            return
        }

        let data: [String: Any] = [
            "title": title,
            "description": description,
            "price": priceValue,
            "isPopular": isPopular,
            "category": category,
            "imagepath": imageURL ?? "",
            "isAvailable": isAvailable
        ]

        ref.setData(data) { [weak self] error in
            if let error = error {
                self?.errorMessage = "Failed to save item: \(error.localizedDescription)"
                self?.isUploading = false
            } else {
                self?.saveCustomizations(ref)
            }
        }
    }

    private func saveCustomizations(_ ref: DocumentReference) {
        do {
            for cat in customizations {
                let customizationRef = ref.collection("customizations").document(cat.id)
                try customizationRef.setData(from: cat)
            }
            showSuccessMessage = true
            errorMessage = nil
        } catch {
            errorMessage = "Failed to save customizations."
        }
        isUploading = false
    }

    func reset() {
        title = ""
        description = ""
        price = ""
        isAvailable = true
        isPopular = false
        category = ""
        selectedImage = nil
        imageURL = nil
        customizations = []
        errorMessage = nil
        showSuccessMessage = false
    }
}
