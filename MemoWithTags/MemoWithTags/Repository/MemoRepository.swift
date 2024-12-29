//
//  MemoRepository.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

protocol MemoRepository {
    
}

final class DefaultMemoRepository: MemoRepository {
    ///singleton
    static let shared = DefaultMemoRepository()
}
