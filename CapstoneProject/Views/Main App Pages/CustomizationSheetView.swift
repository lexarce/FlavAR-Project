//
//  CustomizationSheetView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 4/21/25.
//

import SwiftUI

struct CustomizationSheetView: View {
    @ObservedObject var viewModel: CustomizationViewModel
    var basePrice: Double

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Customize your entrée")
                    .font(.title2)
                    .bold()
                    .padding()

                if viewModel.customizations.isEmpty {
                    Text("Loading options...")
                        .padding()
                        .foregroundColor(.gray)
                }

                ScrollView {
                    ForEach(viewModel.customizations.indices, id: \.self) { catIndex in
                        let category = viewModel.customizations[catIndex]
                        VStack(alignment: .leading, spacing: 8) {
                            Text(category.categoryName)
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(category.options.indices, id: \.self) { optIndex in
                                let option = category.options[optIndex]
                                HStack {
                                    Text(option.name)
                                    Spacer()
                                    if let cost = option.additionalCost, cost > 0 {
                                        Text("+$\(cost, specifier: "%.2f")")
                                            .foregroundColor(.orange)
                                    }

                                    if option.selectionType == .checkmark {
                                        Button(action: {
                                            viewModel.toggleCheckmark(categoryIndex: catIndex, optionIndex: optIndex)
                                        }) {
                                            Image(systemName: (option.currentQuantity ?? 0) > 0 ? "checkmark.square.fill" : "square")
                                                .foregroundColor(.blue)
                                        }
                                    } else if option.selectionType == .quantity {
                                        HStack {
                                            Button(action: {
                                                viewModel.decreaseQuantity(categoryIndex: catIndex, optionIndex: optIndex)
                                            }) {
                                                Image(systemName: "minus.circle")
                                            }
                                            Text("\(option.currentQuantity ?? 0)")
                                            Button(action: {
                                                viewModel.increaseQuantity(categoryIndex: catIndex, optionIndex: optIndex)
                                            }) {
                                                Image(systemName: "plus.circle")
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.bottom)
                    }
                }

                Divider()

                Text("Total: $\(totalPrice(), specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()

                Spacer()
            }
            .navigationTitle("Customize")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if viewModel.customizations.isEmpty {
                    print("Sheet appeared, but customization list is empty.")
                }
            }
        }
    }

    func totalPrice() -> Double {
        var total = basePrice
        for category in viewModel.customizations {
            for option in category.options {
                let qty = option.currentQuantity ?? 0
                let price = option.additionalCost ?? 0
                total += Double(qty) * price
            }
        }
        return total
    }
}


// MARK: - Preview
#Preview {
    let mockVM = CustomizationViewModel()
    
    // Simulate fetched customizations
    mockVM.customizations = [
        CustomizationCategory(
            categoryName: "Extras",
            isRequired: false,
            options: [
                CustomizationOption(
                    name: "Extra Kimchi",
                    additionalCost: 1.5,
                    selectionType: .checkmark,
                    maxQuantity: 1,
                    currentQuantity: 1
                ),
                CustomizationOption(
                    name: "Extra Rice",
                    additionalCost: 2.0,
                    selectionType: .quantity,
                    maxQuantity: 3,
                    currentQuantity: 2
                ),
                CustomizationOption(
                    name: "Soybean Paste Soup",
                    additionalCost: 1.0,
                    selectionType: .checkmark,
                    maxQuantity: 1,
                    currentQuantity: 0
                )
            ]
        )
    ]
    
    return CustomizationSheetView(viewModel: mockVM, basePrice: 14.99)
}

