//
//  LoginViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//

import Foundation

final class LoginViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isLoggedIn: Bool = false
    
    private let loginUseCase = DefaultLoginUseCase(authRepository: DefaultAuthRepository.shared)
    
    func login(email: String, password: String) async {
        isLoading = true
    
        let result = await loginUseCase.execute(email: email, password: password)
        isLoading = false
        
        switch result {
        case .success:
            isLoggedIn = true
        case .failure:
            isLoggedIn = false
        }
    }
}
