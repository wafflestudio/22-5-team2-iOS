//
//  AuthDto.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/12/25.
//
import Foundation

struct AuthDto: Decodable {
    let accessToken: String
    let refreshToken: String
    
    func toAuth() -> Auth {
        return Auth(accessToken: accessToken, refreshToken: refreshToken)
    }
}
