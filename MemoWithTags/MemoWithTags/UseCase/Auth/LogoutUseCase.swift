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
        do {
            try await authRepository.logout()
            return .success(())
        } catch let error {
            ///error 맵핑 구현
            return .failure(.from(baseError: error as! BaseError))
        }
    }
}
