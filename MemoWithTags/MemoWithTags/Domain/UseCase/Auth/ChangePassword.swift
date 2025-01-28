//
//  Change.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/26/25.
//

protocol ChangePasswordUseCase {
    func execute(currentPassword: String, newPassword: String) async -> Result<Void, ChangePasswordError>
}

final class DefaultChangePasswordUseCase: ChangePasswordUseCase {
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    
    func execute(currentPassword: String, newPassword: String) async -> Result<Void, ChangePasswordError> {
        do {
            try await authRepository.changePassword(currentPassword: currentPassword, newPassword: newPassword)
            return .success(())
        } catch {
            ///error 맵핑 구현
            return .failure(.from(baseError: error as! BaseError))
        }
    }
}
