//
//  SplashView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import SwiftUI

struct AppRootView: View {
    let container: DIContainer
    
    var body: some View {
        NavigationStack(path: container.$router.path) {
            SplashView(viewModel: .init(container: container))
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .root:
                        SplashView(viewModel: .init(container: container))
                    case .main:
                        MainView(viewModel: .init(container: container))
                    case .login:
                        LoginView(viewModel: .init(container: container))
                    case .signup:
                        SignupView(viewModel: .init(container: container))
                    case .emailVerification(let email):
                        EmailVerificationView(viewModel: .init(container: container), email: email)
                    case .signupSuccess:
                        SignupSuccessView(viewModel: .init(container: container))
                    case .settings:
                        SettingsView(viewModel: .init(container: container))
                    case .search:
                        SearchView()
                    }
                }
        }
        .alert(isPresented: container.$appState.showAlert) {
            return Alert(
                title: Text("Error"),
                message: Text(container.appState.errorMessage),
                dismissButton: .default(Text("확인"))
            )
        }
    }
}
