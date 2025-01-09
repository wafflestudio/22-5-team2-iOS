//
//  SignupUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol SignupUseCase {
    func execute(email: String, password: String) async -> Result<Void, RegisterError>
}

class DefaultSignupUseCase: SignupUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String) async -> Result<Void, RegisterError> {
        do {
            _ = try await authRepository.register(email: email, password: password)
            return .success(())
        } catch let error {
            print(error)
            return .failure(.from(baseError: error as! BaseError))
        }
    }
}
