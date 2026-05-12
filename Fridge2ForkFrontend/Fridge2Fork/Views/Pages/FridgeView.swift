//
//  FridgeView.swift
//  Fridge2Fork
//
//  Created by Shirley Ma on 4/4/25.
//

import SwiftUI

struct FridgeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isAdding: Bool = false
    @State private var isDeleting: Bool = false
    @State private var deletedItems: [(FridgeItem, String)] = []

    @State private var meatItems: [FridgeItem] = [FridgeItem(name: "Chicken", category: "Meat"), FridgeItem(name: "Beef", category: "Meat")]
    @State private var vegItems: [FridgeItem] = [FridgeItem(name: "Broccoli", category: "Vegetables"), FridgeItem(name: "Onion", category: "Vegetables")]
    @State private var dairyItems: [FridgeItem] = [FridgeItem(name: "Eggs", category: "Dairy"), FridgeItem(name: "Blue Cheese", category: "Dairy")]
    
    @State private var isMeatExpanded: Bool = true
    @State private var isVegExpanded: Bool = true
    @State private var isDairyExpanded: Bool = true
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.theme.appCream
                        .ignoresSafeArea()
                    VStack {
                        AppHeaderView()
                            .padding(.bottom, geometry.size.width * -0.6)
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Color.theme.appRed)
                                    .font(.system(size: 25, weight: .bold))
                                    .padding()
                            }
                            .padding(.leading, 15)
                            Spacer()
                        }
                        VStack {
                            Text("Fridge")
                                .font(Font.custom("Rasa-Bold", size: geometry.size.width * 0.1))
                                .foregroundColor(Color.theme.appRed)
                                .padding(.bottom, geometry.size.width * 0.02)
                            VStack {
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 10) {
                                        FridgeModuleView(
                                            fridgeCategory: "Meat",
                                            fridgeItems: $meatItems,
                                            isExpanded: $isMeatExpanded,
                                            isDeleting: $isDeleting,
                                            deletedItems: $deletedItems
                                        )
                                        FridgeModuleView(
                                            fridgeCategory: "Vegetables",
                                            fridgeItems: $vegItems,
                                            isExpanded: $isVegExpanded,
                                            isDeleting: $isDeleting,
                                            deletedItems: $deletedItems
                                        )
                                        FridgeModuleView(
                                            fridgeCategory: "Dairy",
                                            fridgeItems: $dairyItems,
                                            isExpanded: $isDairyExpanded,
                                            isDeleting: $isDeleting,
                                            deletedItems: $deletedItems
                                        )
                                    }
                                    .padding(.top, geometry.size.width * 0.02)
                                    .padding(.horizontal, geometry.size.width * 0.02)
                                }
                            }
                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height * 0.76)
                            .background(Color.theme.appRed)
                            .foregroundColor(Color.theme.appCream)
                            .cornerRadius(20)
                            FridgeButtonsView(
                                isAdding: $isAdding,
                                isDeleting: $isDeleting,
                                deletedItems: $deletedItems,
                                restoreItem: { item, category in
                                    switch category {
                                    case "Meat": meatItems.insert(item, at: 0)
                                    case "Vegetables": vegItems.insert(item, at: 0)
                                    case "Dairy": dairyItems.insert(item, at: 0)
                                    default: break
                                    }
                                }
                            )
                        }
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
    
#Preview {
    FridgeView()
}

