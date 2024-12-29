//
//  TagRepository.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol TagRepository {
    
}

final class DefaultTagRepository: TagRepository {
    ///singleton
    static let shared = DefaultTagRepository()
}
