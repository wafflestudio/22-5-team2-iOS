//
//  User.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

typealias AuthToken = String

struct Auth: Codable {
    let token: AuthToken
}

struct AuthDto: Decodable {
    let token: AuthToken
    
    func toAuth() -> Auth {
        .init(token: token)
    }
}

enum LoginError: Error {
    case invalidCredentials
    case unknown
}

enum LogoutError: Error {
    case networkError
    case unknown
}
