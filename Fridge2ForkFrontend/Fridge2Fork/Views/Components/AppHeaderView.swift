import SwiftUI

struct AppHeaderView: View {
        var body: some View {
            ZStack {
                Image("Teal Ombre")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 110)
                
                VStack {
                    Spacer().frame(height: 40)
                    Image("Rectangle Logo Vector")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                }
            }
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(edges: .top)
        }
    }

#Preview {
    AppHeaderView()
}
