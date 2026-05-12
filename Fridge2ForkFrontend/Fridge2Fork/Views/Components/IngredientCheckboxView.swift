//
//  IngredientCheckboxView.swift
//  Fridge2Fork
//
//  Created by Lucy Wu on 4/3/25.
//

import SwiftUI

struct IngredientCheckboxView: View {
	@Binding var isChecked: Bool
	var ingredientItem: String
	var ingredientAmount: String

	var body: some View {
		HStack {
			Text(ingredientItem)
				.font(Font.custom("Maitree-Medium", size: 20))
				.strikethrough(isChecked, color: Color.appTealLight)
				.foregroundColor(isChecked ? Color.appTealLight : .black)
				.padding(.leading, 15)

			Spacer()

			Text(ingredientAmount)
				.font(Font.custom("Maitree-Medium", size: 20))
				.strikethrough(isChecked, color: Color.appTealLight)
				.foregroundColor(isChecked ? Color.appTealLight : .black)
				.frame(width: 80, alignment: .trailing) // Adjust width as needed

			Spacer().frame(width: 20) // This creates the fixed space between amount and checkbox

			Button(action: {
				isChecked.toggle()
			}) {
				Image(systemName: isChecked ? "checkmark.square.fill" : "square")
					.resizable()
					.frame(width: 21, height: 21)
					.foregroundColor(Color.appTealLight)
			}
			.padding(.trailing, 15)
		}
	}
}

//#Preview {
//	IngredientCheckboxView(
//		isChecked: false,
//		ingredientItem: "Provolone",
//		ingredientAmount: "1 cup"
//	)
//}


