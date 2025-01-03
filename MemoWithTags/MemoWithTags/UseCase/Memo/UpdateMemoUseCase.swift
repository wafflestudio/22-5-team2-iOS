//
//  UpdateMemoUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol UpdateMemoUseCase {
    func execute(memoId: Int, content: String, tags: [Int]) async throws -> Result<Memo, MemoError>
}

class DefaultUpdateMemoUseCase: UpdateMemoUseCase {
    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }

    func execute(memoId: Int, content: String, tags: [Int]) async throws -> Result<Memo, MemoError> {
        do {
            let memo = try await memoRepository.updateMemo(memoId: memoId, content: content, tags: tags)
            return .success(memo)
        } catch let error {
            ///error 맵핑 구현
            return .failure(.networkError)
        }
    }
}
