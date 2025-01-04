//
//  DeleteMemoUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol DeleteMemoUseCase {
    func execute(memoId: Int) async throws -> Result<Void, MemoError>
}

class DefaultDeleteMemoUseCase: DeleteMemoUseCase {
    private let memoRepository: MemoRepository

    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
    }

    func execute(memoId: Int) async throws -> Result<Void, MemoError> {
        do {
            _ = try await memoRepository.deleteMemo(memoId: memoId)
            return .success(())
        } catch let error {
            ///error 맵핑 구현
            return .failure(.networkError)
        }
    }
}
