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
}


