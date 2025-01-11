//
//  UpdateMemoUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol UpdateMemoUseCase {
    func execute(memoId: Int, content: String, tagIds: [Int]) async -> Result<Memo, MemoError>
}

class DefaultUpdateMemoUseCase: UpdateMemoUseCase {
    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }

    func execute(memoId: Int, content: String, tagIds: [Int]) async -> Result<Memo, MemoError> {
        do {
            let dto = try await memoRepository.updateMemo(memoId: memoId, content: content, tagIds: tagIds)
            let memo = dto.toMemo()
            return .success(memo)
        } catch let error as BaseError {
            return .failure(.from(baseError: error))
        } catch {
            return .failure(.unknown)
        }
    }
}
