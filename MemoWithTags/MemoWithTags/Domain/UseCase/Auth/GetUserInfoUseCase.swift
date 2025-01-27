//
//  getUserInfoUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/13/25.
//

protocol GetUserInfoUseCase {
    func execute() async -> Result<User, GetUserInfoError>
}

final class DefaultGetUserInfoUseCase: GetUserInfoUseCase {
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute() async -> Result<User, GetUserInfoError> {
        do {
            let dto = try await authRepository.getUserInfo()
            let user = dto.toUser()
            return .success(user)
        } catch {
            ///error 맵핑 구현
            return .failure(.from(baseError: error as! BaseError))
        }
    }
}
