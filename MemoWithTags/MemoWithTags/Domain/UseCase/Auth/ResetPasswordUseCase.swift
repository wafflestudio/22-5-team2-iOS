//
//  ForgotPasswordUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol ResetPasswordUseCase {
    func execute(email: String, code: String, newPassword: String) async -> Result<Void, ResetPasswordError>
}

final class DefaultResetPasswordUseCase: ResetPasswordUseCase {
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(email:String, code: String, newPassword: String) async -> Result<Void, ResetPasswordError> {
        do {
            try await authRepository.resetPassword(email: email, code: code, newPassword: newPassword)
            return .success(())
        } catch {
            ///error 맵핑 구현
            return .failure(.from(baseError: error as! BaseError))
        }
    }
}
