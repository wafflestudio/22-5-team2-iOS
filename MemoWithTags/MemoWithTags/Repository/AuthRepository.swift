//
//  UserRepository.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

import Foundation
import Alamofire

protocol AuthRepository {
}

final class DefaultAuthRepository: AuthRepository {
    ///singleton
    static let shared = DefaultAuthRepository()
    
}
