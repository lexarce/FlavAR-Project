//
//  CategoryLinkView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/26/25.
//

import SwiftUI

struct CategoryLinkView<Destination: View>: View {
    let destination: Destination
    let imageName: String
    let categoryName: String

    var body: some View {
        NavigationLink(destination: destination) {
            CategoryItemView(imageName: imageName, categoryName: categoryName)
        }
    }
}
