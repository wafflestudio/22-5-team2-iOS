//
//  SplashView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import SwiftUI

struct AppRootView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            SplashView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .root:
                        SplashView()
                    case .main:
                        MainView()
                    case .login:
                        LoginView()
                    case .signup:
                        SignupView()
                    case .emailVerification(let email):
                        EmailVerificationView(email: email)
                    case .signupSuccess:
                        SignupSuccessView()
                    case .settings:
                        SettingsView()
                    case .search:
                        SearchView()
                    }
                }
        }
    }
}
