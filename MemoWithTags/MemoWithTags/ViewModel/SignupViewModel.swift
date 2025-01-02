//
//  SignupViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/2/25.
//

import Foundation

final class SignupViewModel {
    private let signupUseCase = DefaultSignupUseCase(authRepository: DefaultAuthRepository.shared)
    
    func signup(email: String, password: String) {
        
    }
}
