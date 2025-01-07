//
//  FetchMemoUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol FetchMemoUseCase {
    func execute(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?, page: Int) async -> Result<PaginatedMemos, MemoError>
}

class DefaultFetchMemoUseCase: FetchMemoUseCase {
    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }

    func execute(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?, page: Int) async -> Result<PaginatedMemos, MemoError> {
        do {
            let paginatedMemos = try await memoRepository.fetchMemos(content: content, tags: tags, dateRange: dateRange, page: page)
            return .success(paginatedMemos)
        } catch let error as BaseError {
            return .failure(.from(baseError: error))
        } catch {
            return .failure(.unknown)
        }
    }
}

