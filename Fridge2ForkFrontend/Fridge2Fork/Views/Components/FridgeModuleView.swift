//
//  FridgeModuleView.swift
//  Fridge2Fork
//
//  Created by Shirley Ma on 4/4/25.
//

import SwiftUI

struct FridgeModuleView: View {
    var fridgeCategory: String
    @Binding var fridgeItems: [FridgeItem]
    @Binding var isExpanded: Bool
    @Binding var isDeleting: Bool
    @Binding var deletedItems: [(FridgeItem, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(fridgeCategory)
                    .font(Font.custom("Rasa-Bold", size: 35))
                    .foregroundColor(Color.theme.appCream)
                    .padding(.bottom, -10)
                
                Spacer()
                
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .resizable()
                        .frame(width: 24, height: 15)
                        .foregroundColor(Color.theme.appCream)
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: -10) {
                    ForEach($fridgeItems) { $item in
                        HStack {
                            if isDeleting {
                                Button(action: {
                                    deletedItems.insert((item, fridgeCategory), at: 0)
                                    if deletedItems.count > 5 {
                                        deletedItems.removeLast()
                                    }

                                    if let index = fridgeItems.firstIndex(of: item) {
                                        fridgeItems.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()    .frame(width: 24, height: 24)
                                        .foregroundColor(.appCream)
                                }
                                .padding(.trailing, 0)
                            }
                            if isDeleting {
                                TextField("Item name", text: $item.name)
                                    .foregroundColor(Color.theme.appCreamLight)
                            } else {
                                Text(item.name)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 4)
                        .contextMenu {
                            Button(role: .destructive) {
                                deletedItems.insert((item, fridgeCategory), at: 0)
                                if deletedItems.count > 5 {
                                    deletedItems.removeLast()
                                }
                                if let index = fridgeItems.firstIndex(of: item) {
                                    fridgeItems.remove(at: index)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }.font(Font.custom("Maitree-Medium", size: 24))
                        .foregroundColor(Color.theme.appCream)
                    
                }
            }
        }
        .padding()
        .background(Color.theme.appRed)
        .cornerRadius(15)
        
    }
}

#Preview {
    FridgeModulePreviewContainer()
}

struct FridgeModulePreviewContainer: View {
    @State private var meatItems: [FridgeItem] = [
        FridgeItem(name: "Chicken", category: "Meat"),
        FridgeItem(name: "Beef", category: "Meat")
    ]
    
    @State private var isDeleting: Bool = false
    @State private var isExpanded: Bool = true
    @State private var deletedItems: [(FridgeItem, String)] = []

    var body: some View {
        FridgeModuleView(
            fridgeCategory: "Meat",
            fridgeItems: $meatItems,
            isExpanded: $isExpanded,
            isDeleting: $isDeleting,
            deletedItems: $deletedItems
        )
    }
}

