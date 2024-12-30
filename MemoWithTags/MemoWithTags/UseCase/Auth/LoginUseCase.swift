//
//  LoginUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol LoginUseCase {
    func execute(email: String, password: String) async -> Result<Auth, LoginError>
}

class DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(email: String, password: String) async -> Result<Auth, LoginError> {
        return await authRepository.login(email: email, password: password)
    }
}

