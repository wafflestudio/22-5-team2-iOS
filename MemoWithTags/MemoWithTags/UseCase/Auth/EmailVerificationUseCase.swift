//
//  EmailVerificationUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/30/24.
//

protocol EmailVerificationUseCase {
    func execute(email: String) async -> Result<Auth, VerifyEmailError>
}

final class DefaultEmailVerificationUseCase: EmailVerificationUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(email: String) async -> Result<Auth, VerifyEmailError> {
        do {
            let auth = try await authRepository.verifyEmail(email: email)
            return .success(auth)
        } catch {
            ///error 맵핑 구현
            return .failure(.notMatchCode)
        }
    }
}
