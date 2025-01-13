//
//  SocialLoginUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol SocialLoginUseCase {
    
}

final class DefaultSocialLoginUseCase: SocialLoginUseCase {
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}
