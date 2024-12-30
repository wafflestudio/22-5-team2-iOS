//
//  LogoutUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol LogoutUseCase {
    func execute() async -> Result<Void, LogoutError>
}

class DefaultLogoutUseCase: LogoutUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute() async -> Result<Void, LogoutError> {
        return await authRepository.logout()
    }
}
