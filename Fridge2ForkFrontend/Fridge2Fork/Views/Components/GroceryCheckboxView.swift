//
//  CheckboxView.swift
//  Fridge2Fork
//
//  Created by Shirley Ma on 3/24/25.
//

import SwiftUI

struct GroceryCheckboxView: View {
    @State private var isChecked: Bool = false
    var groceryItem: String
    
    var body: some View {
        HStack {
            Button(action: {
                isChecked.toggle()
            }) {
                Image (systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(isChecked ? Color.theme.appTeal : Color.theme.appCream)
                
            }
            
            Text(groceryItem)
                .font(Font.custom("Maitree-Medium", size: 24))
                .strikethrough(isChecked, color: .black)
                .foregroundColor(isChecked ? Color.theme.appCreamLight : Color.theme.appCream)
            Spacer()
        }
    }
}

#Preview {
    GroceryCheckboxView(groceryItem: "Feta")
}
