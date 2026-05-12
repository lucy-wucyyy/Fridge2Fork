//
//  StartView.swift
//  Fridge2Fork
//
//  Created by Shirley Ma on 3/4/25.
//

import SwiftUI

struct StartView: View {
    @State private var showLogin = false
    @State private var showCreateAccount = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.theme.appCream
                        .ignoresSafeArea()
                    VStack (spacing: 0) {
                        Text("Welcome to")
                            .font(Font.custom("Rasa",  size: geometry.size.width * 0.14))
                        
                        // Logo
                        Image("Rectangle Logo Vector")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.8)
                            .padding(.bottom, geometry.size.height * 0.02)
                        Text("Food made easy.")
                            .font(Font.custom("Maitree-Medium", size: geometry.size.width * 0.065))
                            .padding(.bottom, geometry.size.height * 0.03)
                        
                        // Login Button
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .font(Font.custom("Maitree-Medium", size: geometry.size.width * 0.075))
                                .frame(width: geometry.size.width * 0.82, height: geometry.size.height * 0.11)
                                .background(Color.theme.appRed)
                                .foregroundColor(Color.theme.appCream)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y:6)
                                .padding(.bottom, geometry.size.height * 0.02)
                        }
                        
                        // Create Account Button
                        NavigationLink(destination: CreateAccountView()) {
                            Text("Create Account")
                                .font(Font.custom("Maitree-Medium", size: geometry.size.width * 0.075))
                                .frame(width: geometry.size.width * 0.82, height: geometry.size.height * 0.11)
                                .background(Color.theme.appRed)
                                .foregroundColor(Color.theme.appCream)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 6)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    StartView()
}
