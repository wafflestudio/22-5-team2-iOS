//
//  UserRepository.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol UserRepository {
    
}

final class DefaultUserRepository: UserRepository {
    ///singleton
    static let shared = DefaultUserRepository()
    
}
