//
//  SignupUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol SignupUseCase {
    func execute(email: String, password: String) async -> Result<Void, LoginError>
}

class DefaultSignupUseCase: SignupUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

}
