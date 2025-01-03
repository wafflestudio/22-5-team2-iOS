//
//  ForgotPasswordUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/30/24.
//
import Foundation


protocol ForgotPasswordUseCase {
    func execute(email: String) async -> Result<Void, ForgotPasswordError>
}

final class DefaultForgotPasswordUseCase: ForgotPasswordUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(email: String) async -> Result<Void, ForgotPasswordError> {
        do {
            try await authRepository.forgotPassword(email: email)
            return .success(())
        } catch {
            ///error 맵핑 구현
            return .failure(.notMatchCode)
        }
    }
}
