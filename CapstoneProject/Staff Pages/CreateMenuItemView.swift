//
//  CreateMenuItemView.swift
//  CapstoneProject
//
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
                onImageUpload?(imageURL) // notify parent when the image URL changes
            }
        }
    }

    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }

    var onImageUpload: ((String) -> Void)? // closure to notify `EditableImageView`

    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }

        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    uploadImageToFirebase(imageData: data)
                }
            }
        }
    }

    private func uploadImageToFirebase(imageData: Data) {
        let storageRef = Storage.storage().reference().child("menu_images/\(UUID().uuidString).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            storageRef.downloadURL { url, error in
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
    
    var menuItem: MenuItem

    @State private var title: String
    @State private var description: String
    @State private var price: String
    @State private var customizations: [String] = []
    @State private var newCustomization: String = "Add customization"
    @State private var imageURL: String? // Store uploaded image URL
    @State private var selectedImage: UIImage? = nil

    
    @State private var isPopular: Bool
    @State private var category: String
    
    @State private var isEditingTitle: Bool = false
    @State private var isEditingPrice: Bool = false
    @State private var isEditingDescription: Bool = false
    
    @State private var errorMessage: String? // to show error message if any field is empty
    @State private var showSuccessMessage: Bool = false
    
    let db = Firestore.firestore()

    init(menuItem: MenuItem = MenuItem(title: "", description: "", price: 0.0, imagepath: "", category: "", isPopular: false)) {
        self.menuItem = menuItem
        _title = State(initialValue: menuItem.title)
        _description = State(initialValue: menuItem.description)
        _price = State(initialValue: String(format: "%.2f", menuItem.price))
        _isPopular = State(initialValue: menuItem.isPopular)
        _category = State(initialValue: menuItem.category)
    }

    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(imageName: "EditMenuItemBG")
                VStack(spacing: 0) {
                    Spacer().frame(height: 50)

                    EditableImageView(
                        imageName: "DefaultFoodImage",
                        onImageUpload: { newURL in
                            self.imageURL = newURL
                        },
                        onImageSelect: { newImage in
                            self.selectedImage = newImage
                        }
                    )

                    MenuItemName(title: $title, isEditingTitle: $isEditingTitle, onTitleChange: { newTitle in
                        self.title = newTitle // update title in main view
                    })

                    Spacer()

                    ScrollView {
                        PriceView(price: $price, isEditingPrice: $isEditingPrice, onPriceChange: { newPrice in
                            self.price = newPrice // update price when editing stops
                        })
                        
                        DescriptionView(description: $description, isEditingDescription: $isEditingDescription, onDescriptionChange: { newDescription in
                            self.description = newDescription // update description when editing stops
                        })
                        
                        AddCustomizationView(newCustomization: $newCustomization, customizations: $customizations)

                        // edit customization view (editing existing items)
                        EditCustomizationView(customizations: $customizations)
                        
                        AvailabilityView()
                        
                        // error message if validation fails
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }

                        // success message if item is saved
                        if showSuccessMessage {
                            Text("Item saved successfully!")
                                .foregroundColor(.green)
                                .padding()
                        }

                        // Temporary Save Button
                        Button(action: {
                            saveMenuItem()
                        }) {
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
    
    // function to save menu item and update firebase data
    func saveMenuItem() {
        guard !title.isEmpty,
              !description.isEmpty,
              !price.isEmpty,
              !category.isEmpty,
              let priceValue = Double(price) else {
            errorMessage = "Please fill in all fields correctly before saving."
            showSuccessMessage = false
            return
        }

        // use `menuItem.id` if available, otherwise fall back to `title`
        let menuItemRef = db.collection("MenuItems").document(menuItem.id ?? title)

        // check if a new image has been selected
        if let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) {
            uploadImageToFirebase(imageData: imageData) { uploadedURL in
                self.imageURL = uploadedURL
                self.saveMenuItemData(menuItemRef: menuItemRef, priceValue: priceValue)
            }
        }
        else {
            // no new image, just save menu item
            saveMenuItemData(menuItemRef: menuItemRef, priceValue: priceValue)
        }
    }

    // helper function to save menu item data
    func saveMenuItemData(menuItemRef: DocumentReference, priceValue: Double) {
        let menuItemData: [String: Any] = [
            "title": title,
            "description": description,
            "price": priceValue,
            "isPopular": isPopular,
            "category": category,
            "imagepath": imageURL ?? "", // save the latest image URL
            "isAvailable": true
        ]

        menuItemRef.setData(menuItemData) { error in
            if let error = error {
                print("Error saving menu item: \(error)")
                errorMessage = "Failed to save item."
            } else {
                print("Menu item successfully added/updated!")

                // save customizations as a subcollection
                for customization in customizations {
                    let customizationRef = menuItemRef.collection("customizations").document(customization)
                    customizationRef.setData([:])
                }

                errorMessage = nil
                showSuccessMessage = true
            }
        }
    }
    
    // function to update image on firebase database
    func uploadImageToFirebase(imageData: Data, completion: @escaping (String?) -> Void) {
        let storageRef = Storage.storage().reference().child("menu_images/\(UUID().uuidString).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                if let url = url {
                    print("Image uploaded successfully: \(url.absoluteString)")
                    completion(url.absoluteString)
                } else {
                    completion(nil)
                }
            }
        }
    }


        
}

//view of image
struct EditableImageView: View {
    var imageName: String // default image name
    var onImageUpload: (String) -> Void // closure to send uploaded image URL
    var onImageSelect: (UIImage?) -> Void // notify parent when new image is selected
    
    @StateObject private var viewModel = PhotoPickerViewModel()

    init(imageName: String, onImageUpload: @escaping (String) -> Void, onImageSelect: @escaping (UIImage?) -> Void) {
        self.imageName = imageName
        self.onImageUpload = onImageUpload
        self.onImageSelect = onImageSelect
        _viewModel = StateObject(wrappedValue: PhotoPickerViewModel())
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 320)
                    .clipped()
            } else if let imageURL = viewModel.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else {
                        Image(imageName) // show default image while loading
                    }
                }
                .scaledToFit()
                .frame(height: 320)
                .clipped()
            } else {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 320)
                    .clipped()
            }

            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                Image("DarkEditButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .padding(5)
                    .padding()
            }
        }
        .onAppear {
            viewModel.onImageUpload = { newURL in
                onImageUpload(newURL) // notify parent when upload is complete
            }
        }
        .onChange(of: viewModel.selectedImage) {
            onImageSelect(viewModel.selectedImage) // notify parent when new image is selected
        }

    }
}


// item name and editing functionality
struct MenuItemName: View {
    @Binding var title: String // bind to item's title
    @Binding var isEditingTitle: Bool // bind to track editing state
    
    var onTitleChange: (String) -> Void // closure to send updated title

    var body: some View {
        HStack {
            TextField("Item Name", text: $title, onCommit: {
                onTitleChange(title) // call function when editing ends
            })
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal)
            .background(Color.clear)
            .cornerRadius(0)
            .padding(.leading, 10)
            .disabled(!isEditingTitle)
            
            Spacer()

            Button(action: {
                // toggle editing state
                isEditingTitle.toggle()
                if !isEditingTitle { // when exiting edit mode, update title
                    onTitleChange(title)
                }
            }) {
                Image("EditButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(5)
                    .background(
                        Circle()
                            .fill(Color.clear)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(isEditingTitle ? 1 : 0), lineWidth: 6)
                                    .blur(radius: 6) // Creates a soft glow
                            )
                    )
            }
        }
        .padding(.top, 20)
        .padding(.trailing, 20)
    }
}

// editing price view
struct PriceView: View {
    @Binding var price: String // bind to the price value
    @Binding var isEditingPrice: Bool // track editing state
    var onPriceChange: (String) -> Void // closure to update price in parent view

    var body: some View {
        VStack(alignment: .leading) {
            // ensure the Price label is visible
            Text("Price")
                .font(.headline)
                .foregroundColor(.white) // Make sure it's visible
                .padding(.top, 15) // Adds space above the label

            ZStack {
                // background for the TextField
                LinearGradient(gradient: Gradient(colors: [Color(hex: "C41D21"), Color(hex: "F2A69E")]),
                               startPoint: .leading, endPoint: .trailing)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) // Subtle drop shadow

                HStack {
                    // textField for entering price
                    TextField("Enter price", text: $price, onCommit: {
                        formatAndSavePrice()
                    })
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.clear)
                    .disabled(!isEditingPrice)

                    // edit button with glowing effect when active
                    Button(action: {
                        isEditingPrice.toggle()
                        if !isEditingPrice { // when editing stops, format the price
                            formatAndSavePrice()
                        }
                    }) {
                        Image("EditButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(5)
                            .background(
                                Circle()
                                    .fill(Color.clear)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(isEditingPrice ? 1 : 0), lineWidth: 6)
                                            .blur(radius: 6)
                                    )
                            )
                    }
                }
                .padding(.trailing, 4)
            }
            .frame(height: 50)
            Spacer()
        }
        .padding(.leading, 10)
        .padding(.horizontal)
    }

    // formats price before saving
    private func formatAndSavePrice() {
        if let doubleValue = Double(price) {
            price = String(format: "%.2f", doubleValue) // ensures price has two decimal places
            onPriceChange(price) // update price in parent view
        }
    }
}

// editing the description
struct DescriptionView: View {
    @Binding var description: String // bind to the description value
    @Binding var isEditingDescription: Bool // bind to track editing state
    var onDescriptionChange: (String) -> Void // closure to update description in parent view

    var body: some View {
        VStack(alignment: .leading) {
            // Label for description
            Text("Description")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 15)

            ZStack {
                // background with gradient styling
                LinearGradient(gradient: Gradient(colors: [Color(hex: "C41D21"), Color(hex: "F2A69E")]),
                               startPoint: .leading, endPoint: .trailing)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)

                HStack {
                    ZStack(alignment: .bottomTrailing) { // align the button at the bottom-right
                        // description Input Field
                        TextEditor(text: $description)
                            .frame(height: 100)
                            .padding()
                            .scrollContentBackground(.hidden) // hides the white background of TextEditor
                            .background(Color.clear)
                            .disabled(!isEditingDescription)
                            .onSubmit {
                                formatAndSaveDescription()
                            }
                            .onDisappear {
                                formatAndSaveDescription()
                            }

                        // edit Button with Glow Effect
                        Button(action: {
                            isEditingDescription.toggle()
                            if !isEditingDescription { // when toggled off, format description
                                formatAndSaveDescription()
                            }
                        }) {
                            Image("EditButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding(5)
                                .background(
                                    Circle()
                                        .fill(Color.clear)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white.opacity(isEditingDescription ? 1 : 0), lineWidth: 6)
                                                .blur(radius: 6) // creates a soft glow
                                        )
                                )
                        }
                        .padding(.bottom, 0) // adjust button position
                    }
                }
                .padding(.trailing, 4)
            }
        }
        .padding(.leading, 10)
        .padding(.horizontal)
    }

    // formats description
    private func formatAndSaveDescription() {
        description = description.trimmingCharacters(in: .whitespacesAndNewlines) // remove trailing spaces
        onDescriptionChange(description) // send the updated description to the parent
    }
}

// add item customization
struct AddCustomizationView: View {
    @Binding var newCustomization: String // user's input for customization
    @Binding var customizations: [String] // list of customizations
    @State private var isEditing: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Item Customizations")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 15)

            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "C41D21"), Color(hex: "F2A69E")]),
                               startPoint: .leading, endPoint: .trailing)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)

                HStack {
                    // textField for entering a new customization
                    TextField("Enter Customization", text: $newCustomization)
                        .padding()
                        .background(Color.clear)
                        .disabled(!isEditing)

                    // edit button (for UI purposes)
                    Button(action: {
                        isEditing.toggle()
                        // action here
                    }) {
                        Image("EditButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(5)
                            .background(
                                Circle()
                                    .fill(Color.clear)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(isEditing ? 1 : 0), lineWidth: 6)
                                            .blur(radius: 6) // creates a soft glow
                                    )
                            )

                    }
                    
                    // add button to append customization
                    Button(action: {
                        addCustomization()
                    }) {
                        Image("AddItemCustomizationButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(5)
                    }
                }
                .padding(.trailing, 4)
            }
            .frame(height: 50)

            Spacer()
        }
        .padding(.leading, 10)
        .padding(.horizontal)
    }

    // Adds new customization and resets input field*
    private func addCustomization() {
        let trimmedCustomization = newCustomization.trimmingCharacters(in: .whitespacesAndNewlines)

        if !trimmedCustomization.isEmpty, !customizations.contains(trimmedCustomization) {
            customizations.append(trimmedCustomization) // add to list
            newCustomization = "" // reset the input field
        }
    }
}


// edit existing item customization
struct EditCustomizationView: View {
    @Binding var customizations: [String] // bind to the list of customizations

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            ForEach(customizations.indices, id: \.self) { index in
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color(hex: "C41D21"), Color(hex: "F2A69E")]),
                                   startPoint: .leading, endPoint: .trailing)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)

                    HStack {
                        // editable TextField for each customization
                        TextField("Customization", text: $customizations[index])
                            .padding()
                            .background(Color.clear)

                        // edit button (for UI purposes)
                        /*Button(action: {
                            print("Editing customization at index \(index)")
                        }) {
                            Image("EditButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding(5)
                        }*/

                        // trash button to remove a customization
                        Button(action: {
                            removeCustomization(at: index)
                        }) {
                            Image("Trash Button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding(5)
                        }
                    }
                    .padding(.trailing, 4)
                }
                .frame(height: 50)
            }

            Spacer()
        }
        .padding(.leading, 10)
        .padding(.horizontal)
    }

    // removes a customization
    private func removeCustomization(at index: Int) {
        customizations.remove(at: index)
    }
}

// item name and editing functionality
struct AvailabilityView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Availability")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 15)
        }
    }
    
}


// color extension for hex value usage
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct CreateMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMenuItemView()
    }
}
