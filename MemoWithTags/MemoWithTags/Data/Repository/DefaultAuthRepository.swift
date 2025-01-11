//
//  DefaultAuthRepository.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/12/25.
//

import Foundation
import Alamofire

final class DefaultAuthRepository: AuthRepository {
    ///singleton
    static let shared = DefaultAuthRepository()
    private init() {}
    
    let tokenInterceptor = TokenInterceptor()
    
    func register(email: String, password: String) async throws {
        print("register")
        let response = await AF.request(AuthRouter.register(email: email, password: password)).serializingData().response
        try handleError(response: response)
    }
    
    func login(email: String, password: String) async throws -> AuthDto {
        print("login")
        let response = await AF.request(AuthRouter.login(email: email, password: password)).serializingDecodable(AuthDto.self).response
        let dto = try handleErrorDecodable(response: response)
        
        return dto
    }
    
    func verifyEmail(email: String, code: String) async throws -> AuthDto {
        print("verify email")
        let response = await AF.request(AuthRouter.verifyEmail(email: email, code: code)).serializingDecodable(AuthDto.self).response
        let dto = try handleErrorDecodable(response: response)
        
        return dto
    }
    
    func forgotPassword(email: String) async throws {
        print("forgot password")
        let response = await AF.request(AuthRouter.forgotPassword(email: email)).serializingData().response
        try handleError(response: response)
    }
    
    func resetPassword(email:String, newPassword: String) async throws {
        print("reset password")
        let response = await AF.request(AuthRouter.resetPassword(email: email, newPassword: newPassword)).serializingData().response
        try handleError(response: response)
    }
    
    func refreshToken() async throws -> AuthDto {
        print("refresh token")
        let respone = await AF
            .request(AuthRouter.refreshToken, interceptor: tokenInterceptor).serializingDecodable(AuthDto.self).response
        let dto = try handleErrorDecodable(response: respone)
        
        return dto
    }
    
    func getUserInfo() async throws -> UserDto {
        print("get user info")
        let response = await AF
            .request(AuthRouter.getUserInfo, interceptor: tokenInterceptor).serializingDecodable(UserDto.self).response
        let dto = try handleErrorDecodable(response: response)
        
        return dto
    }
}
