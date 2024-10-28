//
//  CreateMenuItemView.swift
//  CapstoneProject
//
//  Created by kimi on 10/28/24.
//
import SwiftUI
struct CreateMenuItemView: View {
    
    var menuItem: MenuItem // menu item being created

    @State private var title: String
    @State private var description: String
    @State private var price: String
    @State private var isPopular: Bool
    @State private var category: String
    @State private var isEditingTitle: Bool = false // track if the title is being edited
    @State private var isEditingPrice: Bool = false // track if price is being edited
    @State private var isEditingDescription: Bool = false // track if description is being edited
    
    
    // intializer for state variables
    init(menuItem: MenuItem = MenuItem()) {
        self.menuItem = menuItem
        _title = State(initialValue: menuItem.title)
        _description = State(initialValue: menuItem.description)
        _price = State(initialValue: String(format: "%.2f", menuItem.price))
        _isPopular = State(initialValue: menuItem.isPopular)
        _category = State(initialValue: menuItem.category)
    }
    
    var body: some View {
        
        NavigationView {
            ZStack{
                
                BackgroundView(imageName: "EditMenuItemBG")
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 50)
                        
                        EditableImageView(imageName: "DefaultFoodImage") { // get the default image
                            // action for editing or uploading a new image
                            print("Edit Image Button Pressed")
                            // add image upload functionality here
                        }
                        
                        MenuItemName(title: $title, isEditing: $isEditingTitle)
                        PriceView(price: $price)
                        DescriptionView(description: $description)
                        
                    }
                }
            }
        }
    }
}

// view of the image
struct EditableImageView: View {
    var imageName: String // name of image
    var onEdit: () -> Void // closure for edit button action

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 320)
                .clipped() // makes image stay in its bounds

            Button(action: {
                onEdit() // call function when button is pressed
            }) {
                Image("EditButton") // used to edit the image and upload a picture
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .padding(5)
            }
            .cornerRadius(18)
            .padding()
        }
    }
}

// item name and editing functionality
struct MenuItemName: View {
    @Binding var title: String // bind to item's title
    @Binding var isEditing: Bool // bind to track editing state

    var body: some View {
        HStack {
            TextField("Item Name", text: $title, onEditingChanged: { editing in
                // perform any action here if needed when editing starts or ends
            })
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal)
            .background(Color.clear)
            .cornerRadius(0)
            .padding(.leading, 10)
            
            Spacer()

            Button(action: {
                // toggle editing state
                isEditing.toggle()
            }) {
                Image("EditButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(5)
            }
        }
        .padding(.top, 20)
        .padding(.trailing, 20)
    }
}

struct PriceView: View {
    @Binding var price: String // bind to the price value

    var body: some View {
        VStack(alignment: .leading) {

            ZStack {
                // background for the TextField
                LinearGradient(gradient: Gradient(colors: [Color(hex: "C41D21"), Color(hex: "F2A69E")]), startPoint: .leading, endPoint: .trailing)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) // subtle drop shadow
                
                // textField for entering price
                TextField("Enter price", text: $price)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.clear) // Set the TextField background to clear

            }
            .frame(height: 50) // adjust the height as needed
            .padding(.trailing)
        }
    }
}

struct DescriptionView: View {
    @Binding var description: String // bind to the description value

    var body: some View {
        VStack(alignment: .leading) {

            ZStack {
                // background for the TextEditor
                LinearGradient(gradient: Gradient(colors: [Color(hex: "C41D21"), Color(hex: "F2A69E")]), startPoint: .leading, endPoint: .trailing)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) // subtle drop shadow
                
                // textEditor for entering description
                TextEditor(text: $description)
                    .padding()
                    .background(Color.clear) // set the TextEditor background to clear
                    .frame(height: 100) // adjust height as needed
            }
            .padding(.trailing)
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
