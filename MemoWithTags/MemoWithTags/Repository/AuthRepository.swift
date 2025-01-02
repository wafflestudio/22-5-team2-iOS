//
//  UserRepository.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

import Foundation
import Alamofire

protocol AuthRepository {
    ///회원가입하는 함수.
    func register(email: String, password: String) async throws -> Auth
    ///로그인하는 함수. email과 password를 받아 계정 토큰을 반환함
    func login(email: String, password: String) async throws -> Auth
    ///로그아웃하는 함수. 계정 토큰을 받아와 로그아웃을 실행
    func logout() async throws
    ///비밀번호 재설정 요청, 인증하는 함수
    func forgotPassword(email: String) async throws
    ///비밀번호 재설정하는 함수
    func resetPassword(email: String, newPassword: String) async throws
    ///이메일 인증하는 함수
    func verifyEmail(email: String) async throws
}

final class DefaultAuthRepository: AuthRepository {
    ///singleton
    static let shared = DefaultAuthRepository()
    
    func register(email: String, password: String) async throws -> Auth {
        let endpoint = "/auth/register"
        let requestBody = [
            "email": email,
            "password": password
        ]

        let response = try await AF.request(
            endpoint,
            method: .post,
            parameters: requestBody,
            encoding: JSONEncoding.default
        ).serializingDecodable(AuthDto.self).value
        
        return response.toAuth()
    }
    
    func login(email: String, password: String) async throws -> Auth {
        let endpoint = "/auth/login"
        let requestBody = [
            "email": email,
            "password": password
        ]

        let response = try await AF.request(
            endpoint,
            method: .post,
            parameters: requestBody,
            encoding: JSONEncoding.default
        ).serializingDecodable(AuthDto.self).value
        
        return response.toAuth()
    }

    func logout() async throws {
        let endpoint = "/auth/logout"
        
        _ = try await AF.request(
            endpoint,
            method: .post,
            parameters: [:],
            encoding: JSONEncoding.default
        ).serializingData().value
    }
    
    func forgotPassword(email: String) async throws {
        let endpoint = "/auth/forgot-password"
        let requestBody = [
            "email": email
        ]
        
        _ = try await AF.request(
            endpoint,
            method: .post,
            parameters: requestBody,
            encoding: JSONEncoding.default
        ).serializingData().value
    }
    
    func resetPassword(email:String, newPassword: String) async throws {
        let endpoint = "/auth/reset-password"
        let requestBody = [
            "email": email,
            "password": newPassword
        ]
        
        _ = try await AF.request(
            endpoint,
            method: .post,
            parameters: requestBody,
            encoding: JSONEncoding.default
        ).serializingData().value
    }
    
    func verifyEmail(email: String) async throws {
        let endpoint = "/auth/verify-email"
        let requestBody = [
            "email": email
        ]
        
        _ = try await AF.request(
            endpoint,
            method: .get,
            parameters: requestBody,
            encoding: URLEncoding.queryString
        ).serializingData().value
    }
}
