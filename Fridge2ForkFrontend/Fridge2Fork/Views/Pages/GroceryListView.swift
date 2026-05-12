//
//  GroceryListView.swift
//  Fridge2Fork
//
//  Created by Shirley Ma on 3/20/25.
//

import SwiftUI

struct GroceryListView: View {
    @Environment(\.dismiss) private var dismiss
    
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
                            Text("Grocery List")
                                .font(Font.custom("Rasa-Bold", size: geometry.size.width * 0.1))
                                .foregroundColor(Color.theme.appRed)
                                .padding(.bottom, geometry.size.width * 0.02)
                            VStack {
                                ScrollView {
                                    VStack (alignment: .leading, spacing: -7) {
                                        GroceryCheckboxView(groceryItem: "Feta")
                                        GroceryCheckboxView(groceryItem: "Fries")
                                        GroceryCheckboxView(groceryItem: "Friends")
                                    }
                                    .padding(.top, geometry.size.width * 0.03)
                                    .padding(.horizontal, geometry.size.width * 0.05)
                                }
                                Text("Put in fridge!")
                                    .font(Font.custom("Maitree-SemiBold", size: geometry.size.width * 0.05))
                                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.06)
                                    .background(Color.theme.appTeal)
                                    .foregroundColor(Color.theme.appCream)
                                    .cornerRadius(20)
                                    .shadow(color:.black.opacity(0.3), radius: 3, x:0, y: 6)
                                    .padding(.bottom, geometry.size.width * 0.08)
                            }
                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height * 0.82)
                            .background(Color.theme.appRed)
                            .foregroundColor(Color.theme.appCream)
                            .cornerRadius(20)
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
    GroceryListView()
}
