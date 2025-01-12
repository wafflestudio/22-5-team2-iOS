//
//  NetworkInterceptor.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

import Foundation
import Alamofire

final class TokenInterceptor: RequestInterceptor {
    ///header에 토큰 달기
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = KeyChainManager.shared.readAccessToken(),
              let refreshToken = KeyChainManager.shared.readRefreshToken() else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "RefreshToken")
        completion(.success(urlRequest))
    }
    
    private let retryLimit = 2
    
    ///token refresh 구현
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
//            completion(.doNotRetryWithError(error))
//            return
//        }
//        
//        guard request.retryCount < retryLimit else { return completion(.doNotRetryWithError(error)) }
//        Task {
//            do {
//                let auth = try await DefaultAuthRepository.shared.refreshToken()
//                let isAccessSaved = KeyChainManager.shared.saveAccessToken(token: auth.accessToken)
//                let isRefreshSaved = KeyChainManager.shared.saveRefreshToken(token: auth.refreshToken)
//                
//                if isAccessSaved && isRefreshSaved {
//                    return completion(.retry)
//                } else {
//                    ///재로그인 요청 구현
//                    return completion(.doNotRetry)
//                }
//            } catch {
//                ///재로그인 요청 구현
//                return completion(.doNotRetry)
//            }
//        }
    }
}

