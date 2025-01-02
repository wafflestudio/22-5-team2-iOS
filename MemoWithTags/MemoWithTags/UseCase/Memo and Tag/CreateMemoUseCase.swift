//
//  CreateMemoUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol CreateMemoUseCase {
    func execute(content: String, tags: [Int]) async throws -> Memo
}

class DefaultCreateMemoUseCase: CreateMemoUseCase {
    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }

    func execute(content: String, tags: [Int]) async throws -> Memo {
        return try await memoRepository.createMemo(content: content, tags: tags)
    }
}
