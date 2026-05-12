import SwiftUI

struct WelcomeViewButton: View {
    var title: String
    var destination: AnyView

    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(Font.custom("Maitree-Medium", size: 28))
                .frame(width: 340, height: 80)
                .background(Color.theme.appRed)
                .foregroundColor(Color.theme.appCream)
                .cornerRadius(15)
                .shadow(color: Color.theme.appTeal.opacity(0.9), radius: 3, x: 0, y: 6)
        }
    }
}

#Preview {
    WelcomeViewButton(title: "Start Cooking!", destination: AnyView(GroceryListView()))
}
