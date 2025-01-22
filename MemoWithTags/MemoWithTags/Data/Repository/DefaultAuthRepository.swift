//
//  DefaultAuthRepository.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/12/25.
//

import Foundation
import Alamofire

final class DefaultAuthRepository: AuthRepository {
    
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
        print("accessToken: \(dto.accessToken)")
        return dto
    }
    
    func verifyEmail(email: String, code: String) async throws {
        print("verify email")
        let response = await AF.request(AuthRouter.verifyEmail(email: email, code: code)).serializingData().response
        try handleError(response: response)
    }
    
    func forgotPassword(email: String) async throws {
        print("forgot password")
        let response = await AF.request(AuthRouter.forgotPassword(email: email)).serializingData().response
        try handleError(response: response)
    }
    
    func resetPassword(email:String, code: String, newPassword: String) async throws {
        print("reset password")
        let response = await AF.request(AuthRouter.resetPassword(email: email, code: code, newPassword: newPassword)).serializingData().response
        try handleError(response: response)
    }
    
    func getUserInfo() async throws -> UserDto {
        print("get user info")
        let response = await AF
            .request(AuthRouter.getUserInfo, interceptor: tokenInterceptor).serializingDecodable(UserDto.self).response
        let dto = try handleErrorDecodable(response: response)
        
        return dto
    }
    
    func kakaoLogin(authCode: String) async throws -> AuthDto {
        print("kakao login")
        let response = await AF.request(AuthRouter.kakaoLogin(authCode: authCode)).serializingDecodable(AuthDto.self).response
        let dto = try handleErrorDecodable(response: response)
        print("accessToken: \(dto.accessToken)")
        return dto
    }
    
    func naverLogin(authCode: String) async throws -> AuthDto {
        print("naver login")
        let response = await AF.request(AuthRouter.naverLogin(authCode: authCode)).serializingDecodable(AuthDto.self).response
        let dto = try handleErrorDecodable(response: response)
        print("accessToken: \(dto.accessToken)")
        return dto
    }
    
    func googleLogin(authCode: String) async throws -> AuthDto {
        print("google login")
        let response = await AF.request(AuthRouter.googleLogin(authCode: authCode)).serializingDecodable(AuthDto.self).response
        let dto = try handleErrorDecodable(response: response)
        print("accessToken: \(dto.accessToken)")
        return dto
    }
}
