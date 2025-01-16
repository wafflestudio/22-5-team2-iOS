//
//  EmailVerificationUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/30/24.
//

protocol EmailVerificationUseCase {
    func execute(email: String, code: String) async -> Result<Void, VerifyEmailError>
}

final class DefaultEmailVerificationUseCase: EmailVerificationUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(email: String, code: String) async -> Result<Void, VerifyEmailError> {
        do {
            try await authRepository.verifyEmail(email: email, code: code)
            return .success(())
        } catch {
            return .failure(.from(baseError: error as! BaseError))
        }
    }
}
