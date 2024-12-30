//
//  UpdateMemoUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol UpdateMemoUseCase {
    func execute(memoId: Int, content: String, tags: [Int]) async throws -> Memo
}

class DefaultUpdateMemoUseCase: UpdateMemoUseCase {
    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }

    func execute(memoId: Int, content: String, tags: [Int]) async throws -> Memo {
        return try await memoRepository.updateMemo(memoId: memoId, content: content, tags: tags)
    }
}
