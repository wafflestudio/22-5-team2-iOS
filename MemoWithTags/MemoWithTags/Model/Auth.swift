//
//  User.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//
import Foundation

typealias AuthToken = String

struct Auth: Codable {
    let accessToken: AuthToken
    let refreshToken: AuthToken
    let expiredAt: Date
}

struct AuthDto: Decodable {
    let access_token: AuthToken
    let refresh_token: AuthToken
    let expires_in: TimeInterval
    
    func toAuth() -> Auth {
        Auth(accessToken: access_token, refreshToken: refresh_token, expiredAt: Date(timeIntervalSinceNow: expires_in))
    }
}


