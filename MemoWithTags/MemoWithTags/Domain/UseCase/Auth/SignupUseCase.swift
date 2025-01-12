//
//  SignupUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol SignupUseCase {
    func execute(email: String, password: String) async -> Result<Void, RegisterError>
}

final class DefaultSignupUseCase: SignupUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String) async -> Result<Void, RegisterError> {
        do {
            try await authRepository.register(email: email, password: password)
            return .success(())
        } catch let error {
            return .failure(.from(baseError: error as! BaseError))
        }
    }
}