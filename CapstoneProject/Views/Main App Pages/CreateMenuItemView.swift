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

struct CreateMenuItemView: View {
    @StateObject private var viewModel = CreateMenuItemViewModel()
    @StateObject private var imageViewModel = PhotoPickerViewModel(uploadFolder: "menu_images")

    @State private var isEditingTitle = false
    @State private var isEditingPrice = false
    @State private var isEditingDescription = false

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(imageName: "EditMenuItemBG")

                VStack(spacing: 0) {
                    Spacer().frame(height: 50)

                    EditableImageView(
                        imageName: "DefaultFoodImage",
                        viewModel: imageViewModel
                    )


                    MenuItemName(
                        title: $viewModel.title,
                        isEditingTitle: $isEditingTitle,
                        onTitleChange: { viewModel.title = $0 }
                    )

                    Spacer()

                    ScrollView {
                        PriceView(
                            price: $viewModel.price,
                            isEditingPrice: $isEditingPrice,
                            onPriceChange: { viewModel.price = $0 }
                        )

                        DescriptionView(
                            description: $viewModel.description,
                            isEditingDescription: $isEditingDescription,
                            onDescriptionChange: { viewModel.description = $0 }
                        )

                        CustomizationEditor(customizations: $viewModel.customizations)
                        EditableCategoryView(category: $viewModel.category)
                        ToggleView(isAvailable: $viewModel.isAvailable, isPopular: $viewModel.isPopular)

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }

                        if viewModel.showSuccessMessage {
                            Text("Item saved successfully!")
                                .foregroundColor(.green)
                                .padding()
                        }

                        Button(action: {
                            viewModel.save()
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
}

struct EditableImageView: View {
    var imageName: String
    @ObservedObject var viewModel: PhotoPickerViewModel

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
                        Image(imageName)
                            .resizable()
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

// edit customization
struct CustomizationEditor: View {
    @Binding var customizations: [CustomizationCategory]
    
    @State private var newCategoryName: String = ""
    @State private var newOptionInputs: [String: CustomizationOptionInput] = [:]

    struct CustomizationOptionInput {
        var name: String = ""
        var cost: String = ""
        var selectionType: SelectionType = .checkmark
        var maxQuantity: String = ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Customizations")
                .font(.title2)
                .bold()
                .foregroundColor(.white)

            ForEach(customizations.indices, id: \.self) { i in
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(customizations[i].categoryName)
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            customizations.remove(at: i)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }

                    ForEach(customizations[i].options.indices, id: \.self) { j in
                        HStack {
                            Text(customizations[i].options[j].name)
                                .foregroundColor(.white)
                            Spacer()
                            Button {
                                customizations[i].options.remove(at: j)
                            } label: {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        let cat = customizations[i].categoryName
                        let binding = Binding(get: {
                            newOptionInputs[cat] ?? CustomizationOptionInput()
                        }, set: { newOptionInputs[cat] = $0 })

                        CustomizationOptionInputView(input: binding) {
                            if let input = newOptionInputs[cat], !input.name.isEmpty {
                                let option = CustomizationOption(
                                    name: input.name,
                                    additionalCost: Double(input.cost) ?? 0.0,
                                    selectionType: input.selectionType,
                                    maxQuantity: input.selectionType == .quantity ? Int(input.maxQuantity) : nil,
                                    currentQuantity: 0
                                )
                                customizations[i].options.append(option)
                                newOptionInputs[cat] = CustomizationOptionInput()
                            }
                        }
                    }
                }
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "C41D21"), Color(hex: "F2A69E")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .cornerRadius(12)
                    .shadow(radius: 4)
                )
            }

            Divider().padding(.vertical, 10)

            // styled "new category" field
            HStack {
                ZStack {
                    // background gradient
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "C41D21"), Color(hex: "F2A69E")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)

                    TextField("New Category", text: $newCategoryName)
                        .padding()
                        .foregroundColor(.white)
                        .accentColor(.white)
                        .background(Color.clear)
                }
                .frame(height: 45)
                .padding(.trailing, 5)

                Button(action: {
                    let trimmed = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty {
                        let newCategory = CustomizationCategory(categoryName: trimmed, options: [])
                        customizations.append(newCategory)
                        newCategoryName = ""
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                        .padding(.leading, 2)
                        .shadow(radius: 3)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct CustomizationOptionInputView: View {
    @Binding var input: CustomizationEditor.CustomizationOptionInput
    var onAdd: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Add New Option")
                .font(.subheadline)
                .foregroundColor(.white)

            TextField("Option Name", text: $input.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Additional Cost (e.g. 0.50)", text: $input.cost)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Picker("Selection Type", selection: $input.selectionType) {
                Text("Checkmark").tag(SelectionType.checkmark)
                Text("Quantity").tag(SelectionType.quantity)
            }
            .pickerStyle(SegmentedPickerStyle())

            if input.selectionType == .quantity {
                TextField("Max Quantity", text: $input.maxQuantity)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Button("Add") {
                onAdd()
            }
            .foregroundColor(.blue)
        }
    }
}



// toggles including availability and popularity
struct ToggleView: View {
    @Binding var isAvailable: Bool
    @Binding var isPopular: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Toggles")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 15)
            
            Toggle("Available for Order", isOn: $isAvailable)
                .foregroundColor(.black)
                .padding(.top, 5)
                .toggleStyle(SwitchToggleStyle())
            
            Toggle("Popular Item", isOn: $isAvailable)
                .foregroundColor(.black)
                .padding(.top, 5)
                .toggleStyle(SwitchToggleStyle())
        }
        .padding(.leading, 10)
        .padding(.horizontal)
    }
}

// TODO: FIX how it looks in UI
struct EditableCategoryView: View {
    @Binding var category: String

    let categories = ["Jin's Premium Boxes", "Korean Food"]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Category")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 15)

            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "C41D21"), Color(hex: "F2A69E")]),
                               startPoint: .leading, endPoint: .trailing)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

                Picker("Select Category", selection: $category) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .foregroundColor(.white)
            }
            .padding(.horizontal)
        }
        .padding(.leading, 10)
    }
}


struct CreateMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMenuItemView()
    }
}
