//
//  LoginView.swift
//  Fridge2Fork
//
//  Created by Shirley Ma on 3/4/25.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var loginSuccess = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.theme.appCream
                        .ignoresSafeArea()
                    VStack {
                        AppHeaderView()
                        Spacer()
                        VStack {
                            Text("Login")
                                .font(Font.custom("Rasa", size: geometry.size.width * 0.11))
                                .padding(.bottom, geometry.size.width * 0.009)

                            Text("Enter your username:")
                                .font(Font.custom("Maitree-Medium", size: geometry.size.width * 0.06))
                                .padding(.bottom, geometry.size.width * -0.009)

                            TextField("Type here...", text: $username)
                                .font(Font.custom("Maitree-Medium", size: geometry.size.width * 0.06))
                                .padding(geometry.size.width * 0.02)
                                .background(Color.theme.appCream)
                                .foregroundColor(Color.theme.appRed)
                                .cornerRadius(20)
                                .submitLabel(.go)
                                .onSubmit {
                                    print("📩 Submitting login with username: \(username)")
                                    loginWithUsername(username) { success, error in
                                        if success {
                                            print("✅ Login success — navigating to WelcomeView!")
                                            loginSuccess = true
                                        } else {
                                            print("❌ Login failed: \(error ?? "Unknown error")")
                                            errorMessage = error ?? "Login failed"
                                        }
                                    }
                                }
                        }
                        .padding()
                        .padding(.vertical, geometry.size.width * 0.06)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .frame(width: geometry.size.width * 0.85)
                        .background(Color.theme.appRed)
                        .foregroundColor(Color.theme.appCream)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 6)
                        
                        
                        Spacer().frame(height: geometry.size.height * 0.01)

                        Text("Don't have an account?")
                            .font(Font.custom("Maitree-Medium", size: geometry.size.width * 0.045))
                            .padding(.bottom, geometry.size.width * -0.05)

                        NavigationLink(destination: CreateAccountView()) {
                            Text("Create account.")
                                .font(Font.custom("Maitree-Bold", size: geometry.size.width * 0.045))
                                .foregroundColor(Color.black)
                        }

                        Spacer().frame(height: geometry.size.height * 0.28)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $loginSuccess) {
            WelcomeView(username: username)
        }
    }

    func loginWithUsername(_ username: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "http://192.168.10.147:8000/api/login/") else {
            completion(false, "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = ["username": username]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            completion(false, "Failed to encode request body")
            return
        }

        print("🚀 Sending login POST to /api/login/ with: \(payload)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Network error: \(error.localizedDescription)")
                    completion(false, error.localizedDescription)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ No response from server")
                    completion(false, "No response from server")
                    return
                }

                print("📬 Login response code: \(httpResponse.statusCode)")

                if httpResponse.statusCode == 200 {
                    completion(true, nil)
                } else {
                    if let data = data,
                       let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let errorMsg = json["error"] as? String {
                        completion(false, errorMsg)
                    } else {
                        completion(false, "Login failed")
                    }
                }
            }
        }.resume()
    }
}

#Preview {
    LoginView()
}
