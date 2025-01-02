//
//  NetworkConfiguration.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

import Foundation

struct NetworkConfiguration {
    static var accessToken: String? {
        get {
            return DefaultAuthRepository.shared.keychain.readAccessToken()
        }
        set {
            if let token = newValue {
                _ = DefaultAuthRepository.shared.keychain.saveAccessToken(token: token)
            } else {
                _ = DefaultAuthRepository.shared.keychain.deleteAccessToken()
            }
        }
    }
    
    static var refreshToken: String? {
        get {
            return DefaultAuthRepository.shared.keychain.readRefreshToken()
        }
        set {
            if let token = newValue {
                _ = DefaultAuthRepository.shared.keychain.saveRefreshToken(token: token)
            } else {
                _ = DefaultAuthRepository.shared.keychain.deleteRefreshToken()
            }
        }
    }
    
    static let baseURL = "https://ec2-43-201-64-202.ap-northeast-2.compute.amazonaws.com"
    // imageBaseURL 추가하기
}

