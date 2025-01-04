//
//  CreateMemoUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol CreateMemoUseCase {
    func execute(content: String, tags: [Int]) async throws -> Result<Memo, MemoError>
}

class DefaultCreateMemoUseCase: CreateMemoUseCase {
    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }

    func execute(content: String, tags: [Int]) async throws -> Result<Memo, MemoError> {
        do {
            let memo = try await memoRepository.createMemo(content: content, tags: tags)
            return .success(memo)
        } catch let error {
            ///error 맵핑 구현
            return .failure(.networkError)
        }
    }
}
