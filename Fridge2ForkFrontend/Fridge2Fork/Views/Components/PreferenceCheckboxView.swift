//
//  PreferenceCheckboxView.swift
//  Fridge2Fork
//
//  Created by Shirley Ma on 3/27/25.
//

import SwiftUI

struct PreferenceCheckboxView: View {
    @State private var isChecked: Bool = false
    var preferenceItem: String
    
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
            
            Text(preferenceItem)
                .font(Font.custom("Maitree-Medium", size: 24))
                .foregroundColor(isChecked ? Color.theme.appTeal : Color.theme.appCream)
            Spacer()
        }
    }
}

#Preview {
    PreferenceCheckboxView(preferenceItem: "Vegan")
}

