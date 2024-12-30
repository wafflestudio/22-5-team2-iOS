//
//  DeleteMemoUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol DeleteMemoUseCase {
    func execute(memoId: Int) async throws
}

class DefaultDeleteMemoUseCase: DeleteMemoUseCase {
    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }

    func execute(memoId: Int) async throws {
        try await memoRepository.deleteMemo(memoId: memoId)
    }
}
