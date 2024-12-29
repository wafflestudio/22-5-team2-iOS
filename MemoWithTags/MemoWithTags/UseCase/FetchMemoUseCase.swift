//
//  FetchMemoUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol FetchMemoUseCase {
    func execute(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?) async -> [Memo]
}

class DefaultFetchMemoUseCase: FetchMemoUseCase {
    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }

    func execute(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?) async -> [Memo] {
        return await memoRepository.fetchMemos(content: content, tags: tags, dateRange: dateRange)
    }
}
