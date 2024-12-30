//
//  ForgotPasswordUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/30/24.
//

protocol ForgotPasswordUseCase {
    func execute(email: String) async -> Result<Void, ForgotPasswordError>
}

final class ForgotPasswordUseCaseImpl: ForgotPasswordUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(email: String) async -> Result<Void, ForgotPasswordError> {
        return await authRepository.forgotPassword(email: email)
    }
}
