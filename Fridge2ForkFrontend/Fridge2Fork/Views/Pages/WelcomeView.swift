//
//  WelcomeView.swift
//  Fridge2Fork
//
//  Created by Shirley Ma on 3/20/25.
//

import SwiftUI

struct WelcomeView: View {
    let username: String
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.theme.appCream
                        .ignoresSafeArea()
                    
                    VStack {
                        AppHeaderView()
                        Spacer()
                        
                        VStack(alignment: .center) {
                            Text("Welcome,")
                                .font(Font.custom("Rasa-SemiBold", size: geometry.size.width * 0.15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, geometry.size.width * -0.06)
                          
                                Text(username)
                                    .font(Font.custom("Rasa-Medium", size: geometry.size.width * 0.11))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .frame(maxWidth: geometry.size.width * 0.65)
                        .padding(.bottom, geometry.size.width * 0.005)
                        Text("What do you want 2 eat?")
                            .font(Font.custom("Maitree-SemiBold", size: 24))
                            .padding(.bottom, geometry.size.width * -0.01)
                        
                        VStack(spacing: 15) {
                            WelcomeViewButton(title: "Start Cooking!", destination: AnyView(SearchRecipesView()))
                            WelcomeViewButton(title: "Open Fridge", destination: AnyView(FridgeView()))
                            WelcomeViewButton(title: "Saved Recipes", destination: AnyView(SavedRecipesView()))
                            WelcomeViewButton(title: "Grocery List", destination: AnyView(GroceryListView()))
                            WelcomeViewButton(title: "Cooking Preferences", destination: AnyView(CookingPreferencesView()))
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                    }
                    .foregroundColor(Color.theme.appRed)
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    WelcomeView(username: "mark112")
}
