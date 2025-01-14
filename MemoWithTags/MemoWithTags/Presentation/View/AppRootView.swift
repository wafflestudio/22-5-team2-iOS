//
//  SplashView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import SwiftUI

struct AppRootView: View {
    var container: DIContainer
    
    // stateobject로 관리해야하는 viewmodel들 = 큼직큼직한 뷰들
    @StateObject private var mainViewModel: MainViewModel
    @StateObject private var loginViewModel: LoginViewModel
    @StateObject private var signupViewModel: SignupViewModel
    @StateObject private var emailVerificationViewModel: EmailVerificationViewModel
    
    init(container: DIContainer) {
        self.container = container
        
        _mainViewModel = StateObject(wrappedValue: MainViewModel(container: container))
        _loginViewModel = StateObject(wrappedValue: LoginViewModel(container: container))
        _signupViewModel = StateObject(wrappedValue: SignupViewModel(container: container))
        _emailVerificationViewModel = StateObject(wrappedValue: EmailVerificationViewModel(container: container))
    }
    
    var body: some View {
        NavigationStack(path: container.appState.$navigation.path) {
            SplashView(viewModel: .init(container: container))
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .root:
                        SplashView(viewModel: .init(container: container))
                    case .main:
                        MainView(viewModel: mainViewModel)
                    case .login:
                        LoginView(viewModel: loginViewModel)
                    case .signup:
                        SignupView(viewModel: signupViewModel)
                    case .emailVerification(let email):
                        EmailVerificationView(viewModel: emailVerificationViewModel, email: email)
                    case .signupSuccess:
                        SignupSuccessView(viewModel: .init(container: container))
                    case .settings:
                        SettingsView(viewModel: mainViewModel)
                    case .search:
                        SearchView(viewModel: mainViewModel)
                    }
                }
        }
        .alert(isPresented: container.appState.$system.showAlert) {
            return Alert(
                title: Text("Error"),
                message: Text(container.appState.system.errorMessage),
                dismissButton: .default(Text("확인"))
            )
        }
    }
}
