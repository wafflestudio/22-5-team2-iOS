//
//  LoginUseCase.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol LoginUseCase {
    func execute(email: String, password: String) async -> Result<Void, LoginError>
}

class DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(email: String, password: String) async -> Result<Void, LoginError> {
//        do {
//            let auth = try await authRepository.login(email: email, password: password)
//            let isAccessSaved = KeyChainManager.shared.saveAccessToken(token: "sfhafejhligheli")
//            let isRefreshSaved = KeyChainManager.shared.saveRefreshToken(token: "gfjagoiregjaasj")
//            
//            if isAccessSaved && isRefreshSaved {
//                return .success(())
//            } else {
//                return .failure(.tokenSaveError)
//            }
//        } catch let error {
//            print(error)
//            return .failure(.from(baseError: error as! BaseError))
//        }
        
        let isAccessSaved = KeyChainManager.shared.saveAccessToken(token: "sfhafejhligheli")
        let isRefreshSaved = KeyChainManager.shared.saveRefreshToken(token: "gfjagoiregjaasj")
        
        if isAccessSaved && isRefreshSaved {
            return .success(())
        } else {
            return .failure(.tokenSaveError)
        }

    }
}

