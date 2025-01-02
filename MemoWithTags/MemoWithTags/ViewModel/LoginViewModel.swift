//
//  LoginViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//

import Foundation

final class LoginViewModel: ObservableObject {
    private let loginUseCase = DefaultLoginUseCase(authRepository: DefaultAuthRepository.shared)
    
    func login(email: String, password: String) {
        
    }
}
