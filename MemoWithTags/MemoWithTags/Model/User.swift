//
//  User.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

struct User: Codable {
    let email: String
    let nickname: String
}

struct UserDto: Codable {
    let email: String
    let nickname: String
    
    func toUser() -> User {
        User(email: email, nickname: nickname)
    }
}
