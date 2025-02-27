/*///
//  CreateMenuItemView.swift
//  CapstoneProject
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import Firebase
import FirebaseStorage

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    
    @Published var selectedImage: UIImage? = nil
    @Published var imageURL: String? {
        didSet {
            if let imageURL = imageURL {
                onImageUpload?(imageURL) // Notify parent when image URL updates
            }
        }
    }

    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }

    var onImageUpload: ((String) -> Void)? // Closure to notify `EditableImageView`

    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }

        Task {
            if let data = try? await selection.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImage = uiImage
                uploadImageToFirebase(imageData: data)
            }
        }
    }

    private func uploadImageToFirebase(imageData: Data) {
        let storageRef = Storage.storage().reference().child("menu_images/\(UUID().uuidString).jpg")

        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            storageRef.downloadURL { url, _ in
                if let url = url {
                    DispatchQueue.main.async {
                        self.imageURL = url.absoluteString
                    }
                }
            }
        }
    }
}

struct CreateMenuItemView: View {
    
    @State var menuItem: MenuItem
    var from: String

    @State private var imageURL: String? // Store uploaded image URL
    @State private var showSuccessMessage: Bool = false
    @State private var errorMessage: String?

    let db = Firestore.firestore()

    init(menuItem: MenuItem = MenuItem(), from: String = "default") {
        self._menuItem = State(initialValue: menuItem)
        self.from = from
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(imageName: "EditMenuItemBG")
                
                VStack(spacing: 10) {
                    Spacer().frame(height: 50)

                    EditableImageView(imageName: "DefaultFoodImage", onImageUpload: { newURL in
                        self.imageURL = newURL
                    })

                    MenuItemName(title: $menuItem.title)

                    Spacer()

                    ScrollView {
                        PriceView(price: $menuItem.price)
                        DescriptionView(description: $menuItem.description)
                        AddCustomizationView(newCustomization: $menuItem.category)

                        // Error Message
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }

                        // Success Message
                        if showSuccessMessage {
                            Text("Item saved successfully!")
                                .foregroundColor(.green)
                                .padding()
                        }

                        // Save Button
                        Button(action: saveMenuItem) {
                            Text("Save")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(20)
                        .frame(maxWidth: 150)
                    }
                }
            }
        }
    }
    
    func saveMenuItem() {
        guard !menuItem.title.isEmpty,
              !menuItem.description.isEmpty,
              !menuItem.category.isEmpty else {
            errorMessage = "Please fill in all fields correctly before saving."
            showSuccessMessage = false
            return
        }
        
        let menuItemRef = db.collection("MenuItems").document(menuItem.title) // Title as document ID
        
        let menuItemData: [String: Any] = [
            "title": menuItem.title,
            "description": menuItem.description,
            "price": menuItem.price,
            "isPopular": menuItem.isPopular,
            "category": menuItem.category,
            "imagepath": imageURL ?? "" // Store uploaded image URL
        ]
        
        menuItemRef.setData(menuItemData) { error in
            if let error = error {
                print("Error adding document: \(error)")
                errorMessage = "Failed to save item."
            } else {
                print("Menu item successfully added!")
                errorMessage = nil
                showSuccessMessage = true
            }
        }
    }
}

// MARK: - UI Components

struct EditableImageView: View {
    var imageName: String
    var onImageUpload: (String) -> Void
    @StateObject private var viewModel = PhotoPickerViewModel()

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 320)
            } else if let imageURL = viewModel.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else {
                        Image(imageName)
                            .resizable()
                    }
                }
                .scaledToFit()
                .frame(height: 320)
            } else {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 320)
            }

            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                Image("DarkEditButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .padding()
            }
        }
        .onAppear {
            viewModel.onImageUpload = { newURL in
                onImageUpload(newURL)
            }
        }
    }
}

struct MenuItemName: View {
    @Binding var title: String

    var body: some View {
        TextField("Item Name", text: $title)
            .font(.largeTitle.bold())
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(.horizontal)
    }
}

struct PriceView: View {
    @Binding var price: Double

    var body: some View {
        VStack {
            Text("Price")
                .font(.headline)
                .foregroundColor(.white)

            TextField("Enter Price", value: $price, formatter: NumberFormatter())
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .keyboardType(.decimalPad)
                .padding(.horizontal)
        }
    }
}

struct DescriptionView: View {
    @Binding var description: String

    var body: some View {
        VStack {
            Text("Description")
                .font(.headline)
                .foregroundColor(.white)

            TextEditor(text: $description)
                .frame(height: 100)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
}

struct AddCustomizationView: View {
    @Binding var newCustomization: String

    var body: some View {
        VStack {
            Text("Item Customizations")
                .font(.headline)
                .foregroundColor(.white)

            TextField("Enter Customization", text: $newCustomization)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
}

// MARK: - Preview

struct CreateMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMenuItemView(menuItem: MenuItem(), from: "test")
    }
}

*/
