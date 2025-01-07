//
//  UserRepository.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

import Foundation
import Alamofire

protocol AuthRepository: BaseRepository {
    ///회원가입하는 함수.
    func register(email: String, password: String) async throws
    ///로그인하는 함수. email과 password를 받아 계정 토큰을 반환함
    func login(email: String, password: String) async throws -> Auth
    ///비밀번호 재설정 요청, 인증하는 함수
    func forgotPassword(email: String) async throws
    ///비밀번호 재설정하는 함수
    func resetPassword(email: String, newPassword: String) async throws
    ///이메일 인증하는 함수
    func verifyEmail(email: String, code: String) async throws -> Auth
    ///token refresh 함수
    func refreshToken() async throws -> Auth
    ///유저 정보 가져오는 함수
    func getUserInfo() async throws -> User
}

final class DefaultAuthRepository: AuthRepository {
    ///singleton
    static let shared = DefaultAuthRepository()
    private init() {}
    
    let tokenInterceptor = TokenInterceptor()
    
    func register(email: String, password: String) async throws {
        let response = await AF.request(AuthRouter.register(email: email, password: password)).serializingDecodable(AuthDto.self).response
        _ = try handleError(response: response)
    }
    
    func login(email: String, password: String) async throws -> Auth {
        let response = await AF.request(AuthRouter.login(email: email, password: password)).serializingDecodable(AuthDto.self).response
        let dto = try handleError(response: response)
        
        return dto.toAuth()
    }
    
    func verifyEmail(email: String, code: String) async throws -> Auth {
        let response = await AF.request(AuthRouter.verifyEmail(email: email, code: code)).serializingDecodable(AuthDto.self).response
        let dto = try handleError(response: response)
        
        return dto.toAuth()
    }
    
    func forgotPassword(email: String) async throws {
        let response = await AF.request(AuthRouter.forgotPassword(email: email)).serializingData().response
        _ = try handleError(response: response)
    }
    
    func resetPassword(email:String, newPassword: String) async throws {
        let response = await AF.request(AuthRouter.resetPassword(email: email, newPassword: newPassword)).serializingData().response
        _ = try handleError(response: response)
    }
    
    func refreshToken() async throws -> Auth {
        let respone = await AF
            .request(AuthRouter.refreshToken, interceptor: tokenInterceptor).serializingDecodable(AuthDto.self).response
        let dto = try handleError(response: respone)
        
        return dto.toAuth()
    }
    
    func getUserInfo() async throws -> User {
        let response = await AF
            .request(AuthRouter.getUserInfo, interceptor: tokenInterceptor).serializingDecodable(UserDto.self).response
        let dto = try handleError(response: response)
        
        return dto.toUser()
    }
}
