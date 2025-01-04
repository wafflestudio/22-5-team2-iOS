//
//  FetchMemoUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol FetchMemoUseCase {
    func execute(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?) async -> Result<[Memo], MemoError>
}

class DefaultFetchMemoUseCase: FetchMemoUseCase {
    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }

    func execute(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?) async -> Result<[Memo], MemoError> {
        do {
            let memos = try await memoRepository.fetchMemos(content: content, tags: tags, dateRange: dateRange)
            return .success(memos)
        } catch let error {
            ///error 맵핑 구현
            return .failure(.networkError)
        }
    }
}
