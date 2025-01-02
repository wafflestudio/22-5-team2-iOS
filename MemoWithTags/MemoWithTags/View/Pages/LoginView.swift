//
//  MainView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/2/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggingIn: Bool = false
    @State private var loginError: String? = nil
    @EnvironmentObject var appState: AppState
    let authRepository: AuthRepository = DefaultAuthRepository.shared

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .padding()

                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                }

                Button(action: {
                    Task {
                        await login()
                    }
                }) {
                    if isLoggingIn {
                        ProgressView()
                    } else {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .disabled(isLoggingIn)
                .padding(.top)

                Spacer()
            }
            .padding()
            .navigationTitle("Login")
        }
    }

    /// 로그인 함수
    func login() async {
        isLoggingIn = true
        loginError = nil
        let result = await authRepository.login(email: email, password: password)
        switch result {
        case .success(_):
            DispatchQueue.main.async {
                appState.isLoggedIn = true
            }
        case .failure(let error):
            DispatchQueue.main.async {
                loginError = error.localizedDescription
            }
        }
        isLoggingIn = false
    }
}
