//
//  NetworkInterceptor.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

import Foundation
import Alamofire

final class NetworkInterceptor: RequestInterceptor {
    ///header에 토큰 달기
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        completion(.success(urlRequest))
    }
    
    // Retry the request if it's failed due to authentication error (e.g., 401 Unauthorized)
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock(); defer { lock.unlock() }
        
        // Check if the request was already retried
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        requestsToRetry.append(completion)
        
        // If a refresh is already in progress, do not start another one
        if !isRefreshing {
            isRefreshing = true
            
            // Attempt to refresh the Access Token
            Task {
                let result = await authRepository.refreshAccessToken()
                self.lock.lock(); defer { self.lock.unlock() }
                
                switch result {
                case .success(let auth):
                    // Update the tokens in NetworkConfiguration
                    NetworkConfiguration.accessToken = auth.accessToken
                    NetworkConfiguration.refreshToken = auth.refreshToken
                    
                    // Notify all pending requests to retry
                    self.requestsToRetry.forEach { $0(.retry) }
                    self.requestsToRetry.removeAll()
                    
                case .failure(_):
                    // Notify all pending requests to not retry
                    self.requestsToRetry.forEach { $0(.doNotRetry) }
                    self.requestsToRetry.removeAll()
                }
                
                self.isRefreshing = false
            }
        }
    }
}

