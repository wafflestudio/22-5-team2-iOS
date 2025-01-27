//
//  NaverLoginUsecase.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/22/25.
//

protocol NaverLoginUseCase {
    func execute(authCode: String) async -> Result<SocialAuth, SocialLoginError>
}

final class DefaultNaverLoginUseCase: NaverLoginUseCase {
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(authCode: String) async -> Result<SocialAuth, SocialLoginError> {
        do {
            let dto = try await authRepository.naverLogin(authCode: authCode)
            let auth = dto.toAuth()
            
            let isAccessSaved = KeyChainManager.shared.saveAccessToken(token: auth.accessToken)
            let isRefreshSaved = KeyChainManager.shared.saveRefreshToken(token: auth.refreshToken)
            
            if isAccessSaved && isRefreshSaved {
                return .success(auth)
            } else {
                return .failure(.tokenSaveError)
            }
        } catch let error {
            return .failure(.from(baseError: error as! BaseError))
        }
    }
}
