//
//  User.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/12/25.
//

struct UserDto: Codable {
    let id: String
    let email: String
    let nickname: String
    let createdAt: String
    
    func toUser() -> User {
        return User(email: email, nickname: nickname)
    }
}
