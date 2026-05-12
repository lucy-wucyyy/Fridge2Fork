//
//  SearchRecipesView.swift
//  Fridge2Fork
//
//  Created by Lucy Wu on 4/30/25.
//

import SwiftUI

struct SearchRecipesView: View {
    @Environment(\.dismiss) private var dismiss
	@State private var searchText: String = ""
	@State private var allRecipes: [SavedRecipesView.Recipe] = [
		// You can replace these with real recipe data
//		SavedRecipesView.Recipe(name: "Feta Pasta", time: "90 mins", image: "feta_pasta", difficulty: "5/10", calories: "350", ingredients: ["Provolone"], amounts: ["1 cup"], steps: ["Step 1"]),
//		SavedRecipesView.Recipe(name: "French Fries", time: "10 mins", image: "french_fries", difficulty: "1/10", calories: "250", ingredients: ["Potatoes"], amounts: ["3"], steps: ["Step 1"]),
//		SavedRecipesView.Recipe(name: "Falafel", time: "45 mins", image: "falafel", difficulty: "6/10", calories: "300", ingredients: ["Chickpeas"], amounts: ["1 cup"], steps: ["Step 1"]),
//		SavedRecipesView.Recipe(name: "Focaccia", time: "270 mins", image: "focaccia", difficulty: "4/10", calories: "400", ingredients: ["Flour"], amounts: ["2 cups"], steps: ["Step 1"])
	]

	var filteredRecipes: [SavedRecipesView.Recipe] {
		if searchText.isEmpty {
			return allRecipes
		} else {
			return allRecipes.filter { $0.name.lowercased().contains(searchText.lowercased()) }
		}
	}

	var body: some View {
		NavigationStack {
			ZStack {
				Color.theme.appCream.ignoresSafeArea()

				VStack(alignment: .center) {
					AppHeaderView()
                        .padding(.bottom, -110)
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
                    Spacer()
                    Spacer()
                    

					// Title & Search Bar
					VStack(alignment: .center, spacing: 10) {
						Text("What do you want 2 cook?")
							.font(Font.custom("Rasa-Bold", size: 32))
							.foregroundColor(Color.theme.appRed)

						HStack(spacing: 10) {
							Image(systemName: "magnifyingglass")
								.foregroundColor(Color.theme.appCream)
								.font(.system(size: 23, weight: .medium))

							TextField("", text: $searchText)
								.font(Font.custom("Maitree-Bold", size: 18))
								.foregroundColor(Color.theme.appCream)

							Spacer()

							Button(action: {
								// TODO: Add filter button action
							}) {
								Image(systemName: "slider.horizontal.3")
									.foregroundColor(Color.theme.appCream)
									.font(.system(size: 23, weight: .medium))
							}
						}
						.padding(10)
						.background(Color.theme.appRed)
						.cornerRadius(20)
						.shadow(color: Color.theme.appTeal.opacity(0.9), radius: 3, x: 0, y: 6)
						.frame(maxWidth: 335)
					}
					.frame(maxWidth: .infinity)


					Text("Recommended Recipes")
						.font(Font.custom("Maitree-Bold", size: 26))
						.foregroundColor(Color.theme.appRed)
						.padding()
						.padding(.bottom, -20)

					ScrollView {
						if filteredRecipes.isEmpty {
							Text("No recipes found.")
								.font(Font.custom("Maitree-Bold", size: 23))
								.foregroundColor(Color.theme.appTeal)
								.padding()
						} else {
							LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 25) {
								ForEach(filteredRecipes) { recipe in
									SavedRecipesView
										.RecipesView(
											recipe: recipe,
											onUnlike:{},
											onToggleFavorite:{})
								}
							}
							.padding()
						}
					}

					Spacer()
				}
			}
		}
        .navigationBarBackButtonHidden(true)
	}
}

#Preview {
	SearchRecipesView()
}
