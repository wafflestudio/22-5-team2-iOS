//
//  EmailVerificationUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/30/24.
//

protocol EmailVerificationUseCase {
    func execute(email: String, code: String) async -> Result<Void, VerifyEmailError>
}

final class DefaultEmailVerificationUseCase: EmailVerificationUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(email: String, code: String) async -> Result<Void, VerifyEmailError> {
//        do {
//            let auth = try await authRepository.verifyEmail(email: email, code: code)
//            let isAccessSaved = KeyChainManager.shared.saveAccessToken(token: auth.accessToken)
//            let isRefreshSaved = KeyChainManager.shared.saveRefreshToken(token: auth.refreshToken)
//            
//            if isAccessSaved && isRefreshSaved {
//                return .success(())
//            } else {
//                return .failure(.tokenSaveError)
//            }
//
//        } catch {
//            return .failure(.notMatchCode)
//        }
        
        let isAccessSaved = KeyChainManager.shared.saveAccessToken(token: "rusafhrghgarge")
        let isRefreshSaved = KeyChainManager.shared.saveRefreshToken(token: "afewgawrgrgaeg")
        
        if isAccessSaved && isRefreshSaved {
            return .success(())
        } else {
            return .failure(.tokenSaveError)
        }
    }
}
