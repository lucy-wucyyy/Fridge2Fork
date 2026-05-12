//
//  RecipesView.swift
//  Fridge2Fork
//
//  Created by Lucy Wu on 3/9/25.
//

import SwiftUI

struct SavedRecipesView: View {
	@AppStorage("recipeCheckedStates") private var storedCheckedStatesData: Data = Data()
	@State private var recipeCheckedStates: [Int: [String: Bool]] = [:]
	
	// Recipe Model
	struct Recipe: Identifiable, Decodable {
		let id: Int
		let name: String
		let time: String
		let image: String
		let difficulty: String
		let calories: String
		let ingredients: [Ingredient]
		let amounts: [String]
		let steps: [String]
		let is_favorite: Bool
		
		struct Ingredient: Decodable {
			let ingredient: IngredientDetail
			let amount: String
			
			struct IngredientDetail: Decodable {
				let id: Int
				let name: String
			}
		}
	}

	
	struct MealDBResponse: Decodable {
		let meals: [Recipe]
	}
	
	private func toggleFavorite(for recipeID: Int) {
		guard let url = URL(string: "http://192.168.10.147:8000/api/recipes/\(recipeID)/favorite/") else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		// Include auth headers if needed:
		//		 request.setValue("Token \(yourToken)", forHTTPHeaderField: "Authorization")
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				print("Favorite toggle failed: \(error)")
				return
			}
			print("Toggled favorite for recipe \(recipeID)")
		}.resume()
	}
	
	
	//    @State private var recipes: [Recipe] = [
	//        Recipe(name: "Feta Pasta", time: "90 mins", image: "feta_pasta", difficulty: "5/10", calories: "350", ingredients: ["Provolone", "Ground Beef", "Salmon"], amounts: ["1 cup", "16 oz", "2 tbs"], steps: ["Lorem ipsum odor amet, consectetuer adipiscing elit. Inceptos mi vivamus nascetur; nascetur neque tincidunt nisi. Nec velit magnis class imperdiet torquent pulvinar aliquam tristique. Nisi maecenas ac, nibh mauris a magnis.", "2", "3"]),
	//
	//        Recipe(name: "French Fries", time: "10 mins", image: "french_fries", difficulty: "1/10", calories: "350", ingredients: ["a", "b", "c"], amounts: ["1 cup", "16 oz", "2 tbs"], steps: ["Lorem ipsum odor amet, consectetuer adipiscing elit. Inceptos mi vivamus nascetur; nascetur neque tincidunt nisi. Nec velit magnis class imperdiet torquent pulvinar aliquam tristique. Nisi maecenas ac, nibh mauris a magnis.", "2", "3"]),
	//
	//        Recipe(name: "Falafel", time: "45 mins", image: "falafel", difficulty: "6/10", calories: "350", ingredients: ["a", "b", "c"], amounts: ["1 cup", "16 oz", "2 tbs"], steps: ["Lorem ipsum odor amet, consectetuer adipiscing elit. Inceptos mi vivamus nascetur; nascetur neque tincidunt nisi. Nec velit magnis class imperdiet torquent pulvinar aliquam tristique. Nisi maecenas ac, nibh mauris a magnis.", "2", "3"]),
	//
	//		Recipe(name: "Focaccia", time: "270 mins", image: "focaccia", difficulty: "4/10", calories: "350", ingredients: ["Provolone", "Ground Beef", "Salmon", "flour", "water", "butter", "honey"], amounts: ["1 cup", "16 oz", "2 tbs", "1 cup", "I", "love", "Shirley"], steps: ["Lorem ipsum odor amet, consectetuer adipiscing elit. Inceptos mi vivamus nascetur; nascetur neque tincidunt nisi. Nec velit magnis class imperdiet torquent pulvinar aliquam tristique. Nisi maecenas ac, nibh mauris a magnis.", "Lorem ipsum odor amet, consectetuer adipiscing elit. Inceptos mi vivamus nascetur; nascetur neque tincidunt nisi.  Nec velit magnis class imperdiet torquent pulvinar aliquam tristique. Nisi maecenas ac, nibh mauris a magnis.", "Lorem ipsum odor amet, consectetuer adipiscing elit. Inceptos mi vivamus nascetur; nascetur neque tincidunt nisi.  Nec velit magnis class imperdiet torquent pulvinar aliquam tristique. Nisi maecenas ac, nibh mauris a magnis."]),
	//    ]
	@State private var recipes: [Recipe] = []
	
	func fetchRecipes() {
		guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?f=a") else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "GET"

		URLSession.shared.dataTask(with: request) { data, response, error in
			if let data = data {
				do {
					let decoded = try JSONDecoder().decode(MealDBResponse.self, from: data)
					DispatchQueue.main.async {
						self.recipes = decoded.meals
					}
				} catch {
					print("Decoding error: \(error)")
				}
			}
		}.resume()
	}
	
	struct RecipeLink: View {
		let recipe: SavedRecipesView.Recipe
		@Environment(\.dismiss) var dismiss
		@Binding var recipeCheckedStates: [Int: [String: Bool]]
		let onUnlike: (SavedRecipesView.Recipe) -> Void
		let onToggleFavorite: (SavedRecipesView.Recipe) -> Void
		
		var body: some View {
			
			let checkedBinding = Binding<[String: Bool]>(
				get: { recipeCheckedStates[recipe.id, default: [:]] },
				set: {
					recipeCheckedStates[recipe.id] = $0
					saveCheckedStates()
				}
			)
			
			let isLikedBinding = Binding<Bool>(
				get: { true },
				set: { newValue in
					if !newValue {
						onUnlike(recipe)
					}
					onToggleFavorite(recipe)
				}
			)
			
			let toggleFavoriteAction = {
				onToggleFavorite(recipe)
			}
			
			NavigationLink(
				destination: InstructionView(
					recipe: recipe,
					checkedStates: checkedBinding,
					isLiked: isLikedBinding,
					onToggleFavorite: toggleFavoriteAction
				)
			) {
				RecipesView(
					recipe: recipe,
					onUnlike: { onUnlike(recipe) },
					onToggleFavorite: { onToggleFavorite(recipe) }
				)
			}
			
			
			//			NavigationLink(
			//				destination: InstructionView(
			//					recipe: recipe,
			//					checkedStates: Binding(
			//						get: { recipeCheckedStates[recipe.id, default: [:]] },
			//						set: {
			//							recipeCheckedStates[recipe.id] = $0
			//							saveCheckedStates()
			//						}
			//					),
			//					isLiked: Binding(
			//						get: { true }, //set to be true since already in saved recipes
			//						set: { newValue in
			//							if !newValue {onUnlike(recipe)}
			//						}
			//					),
			//					onToggleFavorite: {
			//						onToggleFavorite(recipe)
			//					}
			//				)
			//			) {
			//				RecipesView(recipe: recipe,
			//							onUnlike: {onUnlike(recipe)},
			//							onToggleFavorite: {onToggleFavorite(recipe)}
			//				)
			//			}
		}
		
		private func saveCheckedStates() {
			if let encoded = try? JSONEncoder().encode(recipeCheckedStates) {
				UserDefaults.standard.set(encoded, forKey: "recipeCheckedStates")
			}
		}
	}
	
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color.theme.appCream.ignoresSafeArea()
				
				VStack {
					AppHeaderView()
					
					// Title
					Text("Saved Recipes")
						.font(Font.custom("Rasa-Bold", size: 40))
						.foregroundColor(Color.theme.appRed)
						.padding(.top, -50)
					
					ScrollView {
						// Grid of Recipes
						LazyVGrid(
							columns: [
								GridItem(.flexible()), GridItem(.flexible()),
							], spacing: 25
						) {
							ForEach(recipes) { recipe in
								RecipeLink(
									recipe: recipe,
									recipeCheckedStates: $recipeCheckedStates,
									onUnlike: { removeRecipe($0) },
									onToggleFavorite: { toggleFavorite(for: $0.id) }
								)
							}
							
						}.padding().padding(.top, -16)
						Spacer()
					}
				}
			}
		}.onAppear {
			loadCheckedStates()
			fetchRecipes()
		}
		// auto-saving when the app goes into the background
		.onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
			saveCheckedStates()
		}
	}
	
	private func loadCheckedStates() {
		if let decoded = try? JSONDecoder().decode([Int: [String: Bool]].self, from: storedCheckedStatesData) {
			recipeCheckedStates = decoded
		}
	}
	
	private func saveCheckedStates() {
		if let encoded = try? JSONEncoder().encode(recipeCheckedStates) {
			storedCheckedStatesData = encoded
		}
	}
	
	
	// Remove recipe from list
	private func removeRecipe(_ recipe: Recipe) {
		recipes.removeAll { $0.id == recipe.id }
	}
	
	// Recipe Card View
	struct RecipesView: View {
		let recipe: SavedRecipesView.Recipe
		@State private var isLiked: Bool = true
		let onUnlike: () -> Void  // Callback function when unliked
		let onToggleFavorite: () -> Void
		
		var body: some View {
			
			VStack {
				Image(recipe.image)
					.resizable()
					.scaledToFill()
					.frame(width: 140, height: 102)
					.clipShape(RoundedRectangle(cornerRadius: 15))
					.padding(.top, 20)
				
				Text(recipe.name)
					.font(Font.custom("Maitree-Bold", size: 18))
					.foregroundColor(Color.theme.appCream)
					.padding(.top, -3)
				
				Text(recipe.time)
					.font(Font.custom("Maitree-Medium", size: 12))
					.foregroundColor(Color.theme.appCream)
					.padding(.top, -25)
				
				HStack {
					Button(action: {
						isLiked.toggle()
						if !isLiked {
							onUnlike() // Remove from list when unliked
						}
						onToggleFavorite()
					}) {
						ZStack {
							Image(systemName: "heart.fill")
								.font(.system(size: 20))
								.foregroundColor(Color.theme.appRed)
							
							Image(systemName: "heart") // Stroke outline
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 23, height: 23)
								.foregroundColor(Color.theme.appCream)
						}
					}
					.padding(15).padding(.top, -30) // Adds spacing from edges
					
					Spacer() // Pushes heart to the left
				}
				.padding(.bottom, 8) // Adjust bottom padding for better alignment
				
			}
			.frame(width: 160, height: 200)
			.background(Color.theme.appTeal)
			.cornerRadius(20)
			.shadow(color:.black.opacity(0.3), radius: 3, x:0, y: 6)
		}
	}
	
	
	/* ****************************************
	 ***********  INSTRUCTION PAGE  ***********
	 **************************************** */
	struct InstructionView: View {
		let recipe: Recipe
		@State private var selectedTab: String = "Ingredients"
		@State private var offsetY: CGFloat = 200  // Initial position for the bottom sheet
		@Environment(\.presentationMode) var presentationMode
		@Binding var checkedStates: [String: Bool]
		@Binding var isLiked: Bool
		let onToggleFavorite: () -> Void
		
		private func clearCheckedStatesForThisRecipe() {
			for item in recipe.ingredients {
				checkedStates[item.ingredient.name] = false
			}
		}
		
		private var anyIngredientChecked: Bool {
			recipe.ingredients.contains { checkedStates[$0.ingredient.name] == true }
		}
		
		private func backgroundImageView(for geometry: GeometryProxy) -> some View {
			VStack(spacing: 0) {
				Image(recipe.image)
					.resizable()
					.scaledToFill()
					.frame(width: geometry.size.width, height: geometry.size.height * 0.4)
					.opacity(0.8)
				Spacer()
			}
		}
		
		private func headerControlsView() -> some View {
			HStack {
				// ❌ Close button
				Button(action: {
					presentationMode.wrappedValue.dismiss()
				}) {
					ZStack {
						Circle()
							.fill(Color.appCream)
							.frame(width: 40, height: 40)
						Image(systemName: "xmark")
							.foregroundColor(Color.appRed)
							.font(.system(size: 20, weight: .bold))
					}
				}
				.padding(.leading, 20)
				.padding(.top, 60)
				
				Spacer()
				
				// ❤️ Heart button
				Button(action: {
					isLiked.toggle()
					onToggleFavorite()
					
					if !isLiked {
						presentationMode.wrappedValue.dismiss()
					}
				}) {
					ZStack {
						Circle()
							.fill(Color.appCream)
							.frame(width: 40, height: 40)
						Image(systemName: isLiked ? "heart.fill" : "heart")
							.foregroundColor(Color.appRed)
							.font(.system(size: 20))
					}
				}
				.padding(.trailing, 20)
				.padding(.top, 60)
			}
		}
		
		private func recipeTitleAndInfoView() -> some View {
			VStack(spacing: 10) {
				Text(recipe.name)
					.font(Font.custom("Rasa-Bold", size: 40))
					.foregroundColor(Color.theme.appTeal)

				HStack(spacing: 15) {
					InfoBadge(icon: "⭐️", text: recipe.difficulty)
					InfoBadge(icon: "⏰", text: recipe.time)
					InfoBadge(icon: "🔥", text: "\(recipe.calories) cal")
				}
			}
		}
		
		private func tabSwitcherView() -> some View {
			HStack {
				ZStack {
					RoundedRectangle(cornerRadius: 28)
						.fill(Color.appPink).opacity(0.5)
						.frame(width: .infinity, height: 55)
						.shadow(color:.black.opacity(0.4), radius: 2, x:0, y: 6)

					HStack {
						if selectedTab == "Directions" { Spacer() }
						RoundedRectangle(cornerRadius: 25)
							.fill(Color.appRed)
							.frame(width: 180, height: 48)
							.animation(.easeInOut(duration: 0.2), value: selectedTab)
						if selectedTab == "Ingredients" { Spacer() }
					}
					.frame(width: 364, height: 48)

					HStack {
						Button("Ingredients") {
							selectedTab = "Ingredients"
						}
						.frame(width: 180, height: 45)
						.foregroundColor(selectedTab == "Ingredients" ? Color.appCream :  Color.appTeal)
						.font(Font.custom("Maitree-Medium", size: 22))

						Button("Directions") {
							selectedTab = "Directions"
						}
						.frame(width: 180, height: 45)
						.foregroundColor(selectedTab == "Directions" ? Color.appCream :  Color.appTeal)
						.font(Font.custom("Maitree-Medium", size: 22))
					}
				}
			}
			.padding()
		}

		private func tabContentView() -> some View {
			ScrollView {
				if selectedTab == "Ingredients" {
					VStack(alignment: .leading, spacing: 10) {
						HStack {
							Text("Select/Remove All")
								.font(Font.custom("Maitree-Medium", size: 18))
								.foregroundColor(Color.appRed)
								.padding(.leading, 15)

							Spacer()

							Button(action: {
								let shouldSelectAll = !anyIngredientChecked
								for item in recipe.ingredients {
									checkedStates[item.ingredient.name] = shouldSelectAll
								}
							}) {
								Image(systemName: anyIngredientChecked ? "minus.square.fill" : "checkmark.square")
									.resizable()
									.frame(width: 22, height: 22)
									.foregroundColor(Color.appRed)
							}
							.padding(.trailing, 15)
						}

						VStack(alignment: .leading, spacing: 5) {
							ForEach(recipe.ingredients, id: \.ingredient.id) { item in
								IngredientCheckboxView(
									isChecked: Binding(
										get: { checkedStates[item.ingredient.name, default: false] },
										set: { checkedStates[item.ingredient.name] = $0 }
									),
									ingredientItem: item.ingredient.name,
									ingredientAmount: item.amount
								)
							}
						}
					}
					.padding()
				} else {
					VStack(alignment: .leading, spacing: 12) {
						ForEach(Array(recipe.steps.enumerated()), id: \.0) { index, step in
							VStack(alignment: .leading) {
								Text("Step \(index + 1):")
									.font(Font.custom("Maitree-Bold", size: 22))
									.foregroundColor(Color.black)
								Text(step)
									.font(Font.custom("Maitree-Medium", size: 20))
									.foregroundColor(Color.black)
							}
							.frame(maxWidth: 300, alignment: .leading)
						}
					}
					.padding()
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.frame(width: 370)
			.background(Color.appPink.opacity(0.2))
			.cornerRadius(30)
			.padding(.top, -10)
		}

		private func instructionBottomSheet(geometry: GeometryProxy) -> some View {
			VStack {
				Capsule()
					.frame(width: 40, height: 5)
					.foregroundColor(Color.appTealLight.opacity(0.7))
					.padding(.top, 8)

				recipeTitleAndInfoView()
				tabSwitcherView()
				tabContentView()
				Spacer()
			}
			.frame(width: geometry.size.width, height: geometry.size.height * 0.90)
			.background(Color.appCream)
			.clipShape(RoundedRectangle(cornerRadius: 35))
			.offset(y: offsetY)
			.gesture(
				DragGesture()
					.onChanged { gesture in
						let newOffset = offsetY + gesture.translation.height
						offsetY = min(max(geometry.size.height * 0.1, newOffset), geometry.size.height * 0.3)
					}
					.onEnded { _ in
						offsetY = offsetY < geometry.size.height * 0.3
							? geometry.size.height * 0.1
							: geometry.size.height * 0.3
					}
			)
		}

		
		var body: some View {
			GeometryReader { geometry in
				ZStack {
					backgroundImageView(for: geometry)
					
					VStack {
						headerControlsView()
						Spacer()
					}
					
					instructionBottomSheet(geometry: geometry)
				}
			}
			.ignoresSafeArea()
			.navigationBarBackButtonHidden(true)
		}
		
		//        var body: some View {
		//            GeometryReader { geometry in
		//                ZStack {
		//					backgroundImageView(for: geometry)
		//
		//                    // 👇 CUSTOM ❌ & ❤️ BUTTON HERE
		//					VStack {
		//						HStack {
		//							// ❌ Close button
		//							Button(action: {
		//								presentationMode.wrappedValue.dismiss()
		//							}) {
		//								ZStack {
		//									Circle()
		//										.fill(Color.appCream)
		//										.frame(width: 40, height: 40)
		//
		//									Image(systemName: "xmark")
		//										.foregroundColor(Color.appRed)
		//										.font(.system(size: 20, weight: .bold))
		//								}
		//							}
		//							.padding(.leading, 20)
		//							.padding(.top, 60)
		//
		//							Spacer()
		//
		//							// ❤️ Heart button
		//							Button(action: {
		//								isLiked.toggle()
		//								onToggleFavorite()
		//
		//								// auto dimiss the page if unliked
		//								if !isLiked {
		//									presentationMode.wrappedValue.dismiss()
		//								}
		//							}) {
		//								ZStack {
		//									Circle()
		//										.fill(Color.appCream)
		//										.frame(width: 40, height: 40)
		//
		//									Image(systemName: isLiked ? "heart.fill" : "heart")
		//										.foregroundColor(Color.appRed)
		//										.font(.system(size: 20))
		//								}
		//							}
		//							.padding(.trailing, 20)
		//							.padding(.top, 60)
		//						}
		//						Spacer()
		//					}
		//
		//
		//
		//                    // Draggable Bottom Sheet
		//                    VStack {
		//                        Capsule()
		//                            .frame(width: 40, height: 5)
		//                            .foregroundColor(Color.appTealLight.opacity(0.7))
		//                            .padding(.top, 8)
		//
		//                        Text(recipe.name)
		//                            .font(Font.custom("Rasa-Bold", size: 40))
		//                            .foregroundColor(Color.theme.appTeal)
		//                            .padding(.top, 10)
		//
		//                        // Recipe Info (Difficulty, Time, Calories)
		//                        HStack(spacing: 15) {
		//                            InfoBadge(icon: "⭐️", text: recipe.difficulty)
		//                            InfoBadge(icon: "⏰", text: recipe.time)
		//                            InfoBadge(icon: "🔥", text: "\(recipe.calories) cal")
		//                        }
		//                        .padding(.vertical, 8)
		//                        .padding(.top, -8)
		//
		//
		//                        // Custom Tabs (Buttons)
		//                        HStack {
		//                            ZStack {
		//                                // Background capsule
		//                                RoundedRectangle(cornerRadius: 28)
		//                                    .fill(Color.appPink).opacity(0.5)
		//                                    .frame(width: .infinity, height: 55)
		//                                    .shadow(color:.black.opacity(0.4), radius: 2, x:0, y: 6)
		//
		//                                // Sliding selection indicator
		//                                HStack {
		//                                    if selectedTab == "Directions" {
		//                                        Spacer()
		//                                    }
		//                                    RoundedRectangle(cornerRadius: 25)
		//                                        .fill(Color.appRed)
		//                                        .frame(width: 180, height: 48)
		//                                        .animation(.easeInOut(duration: 0.2), value: selectedTab)
		//
		//                                    if selectedTab == "Ingredients" {
		//                                        Spacer()
		//                                    }
		//                                }
		//                                .frame(width: 364, height: 48)
		//
		//                                // Buttons
		//                                HStack {
		//                                    Button("Ingredients") {
		//                                        selectedTab = "Ingredients"
		//                                    }
		//                                    .frame(width: 180, height: 45)
		//                                    .foregroundColor(selectedTab == "Ingredients" ? Color.appCream :  Color.appTeal)
		//                                    .font(Font.custom("Maitree-Medium", size: 22))
		//
		//                                    Button("Directions") {
		//                                        selectedTab = "Directions"
		//                                    }
		//                                    .frame(width: 180, height: 45)
		//                                    .foregroundColor(selectedTab == "Directions" ? Color.appCream :  Color.appTeal)
		//                                    .font(Font.custom("Maitree-Medium", size: 22))
		//                                }
		//                            }
		//                        }
		//                        .padding()
		//
		//
		//                        // ScrollView for Ingredients or Directions content
		//                        ScrollView {
		//                            // Display Ingredients or Directions based on selectedTab
		//							if selectedTab == "Ingredients" {
		//								VStack(alignment: .leading, spacing: 10) {
		//									HStack {
		//										Text("Select/Remove All")
		//											.font(Font.custom("Maitree-Medium", size: 18))
		//											.foregroundColor(Color.appRed)
		//											.padding(.leading, 15)
		//
		//											Spacer() // Pushes button to the right
		//
		//										Button(action: {
		//												let shouldSelectAll = !anyIngredientChecked
		//												for ingredient in recipe.ingredients {
		//													checkedStates[ingredient] = shouldSelectAll
		//												}
		//											}) {
		//												Image(systemName: anyIngredientChecked ? "minus.square.fill" : "checkmark.square")
		//													.resizable()
		//													.frame(width: 22, height: 22)
		//													.foregroundColor(Color.appRed)
		//											}
		//											.padding(.trailing, 15)
		//										}
		//
		//									VStack(alignment: .leading, spacing: 5) {
		//										ForEach(recipe.ingredients, id: \.ingredient.id) { item in
		//											IngredientCheckboxView(
		//												ingredientItem: item.ingredient.name,
		//												ingredientAmount: item.amount,
		//												isChecked: Binding(
		//													get: { checkedStates[item.ingredient.name, default: false] },
		//													set: { checkedStates[item.ingredient.name] = $0 }
		//												)
		//											)
		//										}
		//									}
		//								}
		//								.padding()
		//							}
		//
		//
		//							else {
		//                                VStack(alignment: .leading, spacing: 12) {
		//                                    ForEach(Array(recipe.steps.enumerated()), id: \.0) { index, step in
		//                                        VStack(alignment: .leading) {
		//                                            Text("Step \(index + 1):")
		//                                                .font(Font.custom("Maitree-Bold", size: 22))
		//                                                .foregroundColor(Color.black)
		//
		//                                            Text(step)
		//                                                .font(Font.custom("Maitree-Medium", size: 20))
		//                                                .foregroundColor(Color.black)
		//                                        }
		//                                        .frame(maxWidth: 300, alignment: .leading)
		//                                    }
		//                                }
		//                                .padding()
		//                            }
		//                        }
		//                        .frame(maxWidth: .infinity, maxHeight: .infinity)  // Ensure ScrollView expands fully
		//                        .frame(width: 370)
		//                        .background(Color.appPink.opacity(0.2))
		//                        .cornerRadius(30)
		//                        .padding(.top, -10)
		//
		//                        Spacer()
		//                    }
		//                    .frame(width: geometry.size.width, height: geometry.size.height * 0.90)
		//                    .background(Color.appCream)
		//                    .clipShape(RoundedRectangle(cornerRadius: 35))
		//                    .offset(y: offsetY)
		//                    .gesture(
		//                        DragGesture()
		//                            .onChanged { gesture in
		//                                let newOffset = offsetY + gesture.translation.height
		//                                offsetY = min(max(geometry.size.height * 0.1, newOffset), geometry.size.height * 0.3)
		//                            }
		//                            .onEnded { _ in
		//                                if offsetY < geometry.size.height * 0.3 {
		//                                    offsetY = geometry.size.height * 0.1  // Snap to 90% (almost fully open)
		//                                } else {
		//                                    offsetY = geometry.size.height * 0.3 // Snap to 70% (default lower position)
		//                                }
		//                            }
		//                    )
		//				}
		//            }
		//            .ignoresSafeArea()
		//            .navigationBarBackButtonHidden(true)
		//        }
	}
	
	
	// Small Component for Displaying Icons + Text
	struct InfoBadge: View {
		let icon: String
		let text: String
		
		var body: some View {
			VStack {
				Text(icon).font(Font.system(size: 30))
				Text(text)
					.font(Font.custom("Maitree-Medium", size: 20))
					.foregroundColor(Color.white)
			}
			.padding(.horizontal, 20)
			.padding(.vertical, 5)
			.background(Color.appTealLight)
			.clipShape(RoundedRectangle(cornerRadius: 20))
			.shadow(color:.black.opacity(0.3), radius: 3, x:0, y: 6)
		}
	}
	
	
	
}


#Preview {
	SavedRecipesView()
}
