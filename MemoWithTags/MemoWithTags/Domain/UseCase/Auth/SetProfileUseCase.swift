//
//  SetProfile.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/26/25.
//

protocol SetProfileUseCase {
    func execute(nickname: String) async -> Result<Void, SetProfileError>
}

final class DefaultSetProfileUseCase: SetProfileUseCase {
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(nickname: String) async -> Result<Void, SetProfileError> {
        do {
            try await authRepository.setProfile(nickname: nickname)
            return .success(())
        } catch {
            ///error 맵핑 구현
            return .failure(.from(baseError: error as! BaseError))
        }
    }
}
