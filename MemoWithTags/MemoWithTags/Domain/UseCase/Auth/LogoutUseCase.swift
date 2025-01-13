//
//  LogoutUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol LogoutUseCase {
    func execute() async -> Result<Void, LogoutError>
}

final class DefaultLogoutUseCase: LogoutUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute() async -> Result<Void, LogoutError> {
        let isAccessDeleted = KeyChainManager.shared.deleteAccessToken()
        let isRefreshDeleted = KeyChainManager.shared.deleteRefreshToken()
        
        if isAccessDeleted && isRefreshDeleted {
            return .success(())
        } else {
            return .failure(.tokenDeleteError)
        }
    }
}
