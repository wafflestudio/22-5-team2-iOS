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
    func register(email: String, password: String) async -> Result<Auth, RegisterError>
    ///로그인하는 함수. email과 password를 받아 계정 토큰을 반환함
    func login(email: String, password: String) async -> Result<Auth, LoginError>
    ///로그아웃하는 함수. 계정 토큰을 받아와 로그아웃을 실행
    func logout() async -> Result<Void, LogoutError>
    ///비밀번호 재설정 요청, 인증하는 함수
    func forgotPassword(email: String) async -> Result<Void, ForgotPasswordError>
    ///비밀번호 재설정하는 함수
    func resetPassword(newPassword: String) async -> Result<Void, ResetPasswordError>
    ///이메일 인증하는 함수
    func verifyEmail(email: String) async -> Result<Void, VerifyEmailError>
}

final class DefaultAuthRepository: AuthRepository {
    ///singleton
    static let shared = DefaultAuthRepository()
    
    func register(email: String, password: String) async -> Result<Auth, RegisterError> {
        let endpoint = "/auth/register"
        let requestBody = [
            "email": email,
            "password": password
        ]

        do {
            let response = try await AF.request(
                endpoint,
                method: .post,
                parameters: requestBody,
                encoding: JSONEncoding.default
            ).serializingDecodable(AuthDto.self).value
            
            return .success(response.toAuth())
        } catch {
            return .failure(.invalidEmail)
        }
    }
    
    func login(email: String, password: String) async -> Result<Auth, LoginError> {
        let endpoint = "/auth/login"
        let requestBody = [
            "email": email,
            "password": password
        ]

        do {
            let response = try await AF.request(
                endpoint,
                method: .post,
                parameters: requestBody,
                encoding: JSONEncoding.default
            ).serializingDecodable(AuthDto.self).value
            
            return .success(response.toAuth())
        } catch {
            return .failure(.invalidCredentials)
        }
    }

    func logout() async -> Result<Void, LogoutError> {
        let endpoint = "/auth/logout"
        
        do {
            _ = try await AF.request(
                endpoint,
                method: .post,
                parameters: [:],
                encoding: JSONEncoding.default
            ).serializingData().value
            
            return .success(())
        } catch {
            return .failure(.networkError)
        }
    }
    
    func forgotPassword(email: String) async -> Result<Void, ForgotPasswordError> {
        let endpoint = "/auth/forgot-password"
        let requestBody = [
            "email": email
        ]

        do {
            _ = try await AF.request(
                endpoint,
                method: .post,
                parameters: requestBody,
                encoding: JSONEncoding.default
            ).serializingData().value

            return .success(())
        } catch {
            return .failure(.invalidEmail)
        }
    }
    
    func resetPassword(newPassword: String) async -> Result<Void, ResetPasswordError> {
        let endpoint = "/auth/reset-password"
        let requestBody = [
            "password": newPassword
        ]

        do {
            _ = try await AF.request(
                endpoint,
                method: .post,
                parameters: requestBody,
                encoding: JSONEncoding.default
            ).serializingData().value

            return .success(())
        } catch {
            return .failure(.invalidPassword)
        }
    }
    
    func verifyEmail(email: String) async -> Result<Void, VerifyEmailError> {
        let endpoint = "/auth/verify-email"
        let requestBody = [
            "email": email
        ]

        do {
            _ = try await AF.request(
                endpoint,
                method: .get,
                parameters: requestBody,
                encoding: URLEncoding.queryString
            ).serializingData().value

            return .success(())
        } catch {
            return .failure(.emailNotFound)
        }
    }
}


enum LoginError: Error {
    case invalidCredentials
    case networkError
    case unknown
}

enum LogoutError: Error {
    case networkError
    case unknown
}

enum RegisterError: Error {
    case emailAlreadyExists
    case invalidEmail
    case networkError
    case unknown
}

enum ForgotPasswordError: Error {
    case invalidEmail
    case UserNotFound
    case networkError
    case unknown
}

enum ResetPasswordError: Error {
    case invalidPassword
    case networkError
    case unknown
}

enum VerifyEmailError: Error {
    case emailNotFound
    case networkError
    case unknown
}
