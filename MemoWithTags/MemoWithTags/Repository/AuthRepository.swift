//
//  UserRepository.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

import Foundation
import Alamofire

protocol AuthRepository {
    ///로그인하는 함수. email과 password를 받아 계정 토큰을 반환함
    func login(email: String, password: String) async -> Result<Auth, LoginError>
    ///로그아웃하는 함수. 계정 토큰을 받아와 로그아웃을 실행
    func logout(token: AuthToken) async -> Result<Void, LogoutError>
}

final class DefaultAuthRepository: AuthRepository {
    ///singleton
    static let shared = DefaultAuthRepository()
    
    func login(email: String, password: String) async -> Result<Auth, LoginError> {
        let endpoint = "/login"
        let requestBody = [
            "username": email,
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

    func logout(token: AuthToken) async -> Result<Void, LogoutError> {
        let endpoint = "/logout"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        do {
            _ = try await AF.request(
                endpoint,
                method: .post,
                parameters: [:],
                encoding: JSONEncoding.default,
                headers: headers
            ).serializingData().value
            
            return .success(())
        } catch {
            return .failure(.networkError)
        }
    }
}
