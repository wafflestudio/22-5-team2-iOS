//
//  SignupUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol SignupUseCase {
    func execute(email: String, password: String) async -> Result<Auth, RegisterError>
}

class DefaultSignupUseCase: SignupUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String) async -> Result<Auth, RegisterError> {
        return await authRepository.register(email: email, password: password)
    }
}
