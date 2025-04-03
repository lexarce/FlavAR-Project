//
//  MenuItemList.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/26/25.
//

import SwiftUI

// Displays filtered menu items in list format

struct MenuItemList: View {
    var menuItems: [MenuItem]
    var searchText: String
    @Binding var selectedItem: MenuItem?
    @Binding var showItemDetail: Bool

    var filteredItems: [MenuItem] {
        searchText.isEmpty ? menuItems : menuItems.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }

    var body: some View {
        List(filteredItems) { item in
            Button(action: {
                selectedItem = item
                showItemDetail = true
            }) {
                HStack {
                    MenuItemImageView(imagePath: item.imagepath)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading) {
                        Text(item.title).font(.headline)
                        Text(formatPrice(item.price)).font(.subheadline).foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(.gray)
                }
            }
        }
        .listStyle(PlainListStyle())
    }

    func formatPrice(_ price: Double) -> String {
        return String(format: "$%.2f", price)
    }
}
