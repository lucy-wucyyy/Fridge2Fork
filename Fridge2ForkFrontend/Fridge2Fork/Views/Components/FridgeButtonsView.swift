//
//  FridgeModuleView.swift
//  Fridge2Fork
//
//  Created by Shirley Ma on 4/4/25.
//

import SwiftUI

struct FridgeButtonsView: View {
    @Binding var isAdding: Bool
    @Binding var isDeleting: Bool
    @Binding var deletedItems: [(FridgeItem, String)]
    var restoreItem: (FridgeItem, String) -> Void
    
    var body: some View {
        HStack(spacing: -8) {
            Button(action: {
                isAdding.toggle()
                if isAdding {
                   isDeleting = false
                }
            }) {
                Image(systemName: isAdding ? "checkmark.circle.fill" : "plus")
                    .resizable()
                    .frame(width: 24, height: 25)
                    .foregroundColor(Color.theme.appRed)
                    .padding()
            }
            Button(action: {
                isDeleting.toggle()
                if isDeleting {
                    isAdding = false
                }
            }) {
                Image(systemName: isDeleting ? "checkmark.circle.fill" : "trash")
                    .resizable()
                    .frame(width: 24, height: 25)
                    .foregroundColor(Color.theme.appRed)
                    .padding()
            }
            Button(action: {
                guard !deletedItems.isEmpty else { return }
                let (item, category) = deletedItems.removeFirst()
                restoreItem(item, category)
            }) {
                Image(systemName: "arrow.uturn.backward")
                    .resizable()
                    .frame(width: 24, height: 25)
                    .foregroundColor(Color.theme.appRed)
                    .padding()
            }
        }
    }
}

#Preview {
    FridgeButtonsPreviewContainer()
}

struct FridgeButtonsPreviewContainer: View {
    @State private var isAdding: Bool = false
    @State private var isDeleting: Bool = false
    @State private var deletedItems: [(FridgeItem, String)] = [
        (FridgeItem(name: "Chicken", category: "Meat"), "Meat")
    ]
    
    @State private var meatItems: [FridgeItem] = []

    var body: some View {
        FridgeButtonsView(
            isAdding: $isAdding,
            isDeleting: $isDeleting,
            deletedItems: $deletedItems,
            restoreItem: { item, category in
                switch category {
                case "Meat":
                    meatItems.insert(item, at: 0)
                default:
                    break
                }
            }
        )
    }
}
