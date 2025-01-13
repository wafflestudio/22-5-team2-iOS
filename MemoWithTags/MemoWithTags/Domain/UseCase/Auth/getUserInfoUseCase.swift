//
//  getUserInfoUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/13/25.
//

protocol getUserInfoUseCase {
    func execute() async -> Result<User, ResetPasswordError>
}

final class DefaultGetUserInfoUseCase: getUserInfoUseCase {
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute() async -> Result<User, ResetPasswordError> {
        do {
            let dto = try await authRepository.getUserInfo()
            let user = dto.toUser()
            return .success(user)
        } catch {
            ///error 맵핑 구현
            return .failure(.unknown)
        }
    }
}
