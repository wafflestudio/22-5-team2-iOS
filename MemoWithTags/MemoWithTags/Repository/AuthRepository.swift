//
//  UserRepository.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

import Foundation
import Alamofire

protocol AuthRepository {
    /// 회원가입하는 함수.
    func register(email: String, password: String) async -> Result<Auth, RegisterError>
    /// 로그인하는 함수. email과 password를 받아 계정 토큰을 반환함
    func login(email: String, password: String) async -> Result<Auth, LoginError>
    /// 로그아웃하는 함수. 계정 토큰을 받아와 로그아웃을 실행
    func logout() async -> Result<Void, LogoutError>
    /// 비밀번호 재설정 요청, 인증하는 함수
    func forgotPassword(email: String) async -> Result<Void, ForgotPasswordError>
    /// 비밀번호 재설정하는 함수
    func resetPassword(email: String, newPassword: String) async -> Result<Void, ResetPasswordError>
    /// 이메일 인증하는 함수
    func verifyEmail(email: String) async -> Result<Void, VerifyEmailError>
    /// Access Token을 갱신하는 함수
    func refreshAccessToken() async -> Result<Auth, RefreshError>
}

final class DefaultAuthRepository: AuthRepository {
    /// Singleton
    static let shared = DefaultAuthRepository()
    
    let keychain = KeychainHelper.shared
    
    private init() {}
    
    func register(email: String, password: String) async -> Result<Auth, RegisterError> {
        let endpoint = "/auth/register"
        let requestBody = [
            "email": email,
            "password": password
        ]

        do {
            let response = try await NetworkSession.shared.request(
                NetworkConfiguration.baseURL + endpoint,
                method: .post,
                parameters: requestBody,
                encoding: JSONEncoding.default
            ).serializingDecodable(AuthDto.self).value

            let auth = response.toAuth()
            
            // 토큰을 Keychain에 저장
            let tokenSaved = keychain.saveAccessToken(token: auth.accessToken) &&
                             keychain.saveRefreshToken(token: auth.refreshToken)
            
            if tokenSaved {
                // NetworkConfiguration에 토큰 업데이트
                NetworkConfiguration.accessToken = auth.accessToken
                NetworkConfiguration.refreshToken = auth.refreshToken
                return .success(auth)
            } else {
                return .failure(.unknown)
            }
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
            let response = try await NetworkSession.shared.request(
                NetworkConfiguration.baseURL + endpoint,
                method: .post,
                parameters: requestBody,
                encoding: JSONEncoding.default
            ).serializingDecodable(AuthDto.self).value

            let auth = response.toAuth()
            
            // 토큰을 Keychain에 저장
            let tokenSaved = keychain.saveAccessToken(token: auth.accessToken) &&
                             keychain.saveRefreshToken(token: auth.refreshToken)
            
            if tokenSaved {
                // NetworkConfiguration에 토큰 업데이트
                NetworkConfiguration.accessToken = auth.accessToken
                NetworkConfiguration.refreshToken = auth.refreshToken
                return .success(auth)
            } else {
                return .failure(.invalidCredentials)
            }
        } catch {
            return .failure(.invalidCredentials)
        }
    }

    func logout() async -> Result<Void, LogoutError> {
        let endpoint = "/auth/logout"
        
        do {
            _ = try await NetworkSession.shared.request(
                NetworkConfiguration.baseURL + endpoint,
                method: .post,
                parameters: [:],
                encoding: JSONEncoding.default
            ).serializingData().value
            
            // Keychain에서 토큰 삭제
            let accessDeleted = keychain.deleteAccessToken()
            let refreshDeleted = keychain.deleteRefreshToken()
            
            if accessDeleted && refreshDeleted {
                // NetworkConfiguration에서 토큰 삭제
                NetworkConfiguration.accessToken = nil
                NetworkConfiguration.refreshToken = nil
                return .success(())
            } else {
                return .failure(.networkError)
            }
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
            _ = try await NetworkSession.shared.request(
                NetworkConfiguration.baseURL + endpoint,
                method: .post,
                parameters: requestBody,
                encoding: JSONEncoding.default
            ).serializingData().value

            return .success(())
        } catch {
            return .failure(.invalidEmail)
        }
    }
    
    func resetPassword(email: String, newPassword: String) async -> Result<Void, ResetPasswordError> {
        let endpoint = "/auth/reset-password"
        let requestBody = [
            "email": email,
            "password": newPassword
        ]

        do {
            _ = try await NetworkSession.shared.request(
                NetworkConfiguration.baseURL + endpoint,
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
            _ = try await NetworkSession.shared.request(
                NetworkConfiguration.baseURL + endpoint,
                method: .get,
                parameters: requestBody,
                encoding: URLEncoding.queryString
            ).serializingData().value

            return .success(())
        } catch {
            return .failure(.emailNotFound)
        }
    }
    
    func refreshAccessToken() async -> Result<Auth, RefreshError> {
        let endpoint = "/auth/refresh-token"
        guard let refreshToken = keychain.readRefreshToken() else {
            return .failure(.invalidRefreshToken)
        }
        
        let requestBody = [
            "refresh_token": refreshToken
        ]
        
        do {
            let response = try await NetworkSession.shared.request(
                NetworkConfiguration.baseURL + endpoint,
                method: .post,
                parameters: requestBody,
                encoding: JSONEncoding.default
            ).serializingDecodable(AuthDto.self).value
            
            let auth = response.toAuth()
            
            // 토큰을 Keychain에 저장
            let tokenSaved = keychain.saveAccessToken(token: auth.accessToken) &&
                             keychain.saveRefreshToken(token: auth.refreshToken)
            
            if tokenSaved {
                // NetworkConfiguration에 토큰 업데이트
                NetworkConfiguration.accessToken = auth.accessToken
                NetworkConfiguration.refreshToken = auth.refreshToken
                return .success(auth)
            } else {
                return .failure(.unknown)
            }
        } catch {
            return .failure(.networkError)
        }
    }
}
