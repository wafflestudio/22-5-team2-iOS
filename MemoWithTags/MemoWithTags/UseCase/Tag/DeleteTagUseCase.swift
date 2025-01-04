//
//  DeleteTagUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol DeleteTagUseCase {
    func execute(tagId: Int) async throws -> Result<Void, MemoError>
}

class DefaultDeleteTagUseCase: DeleteTagUseCase {
    private let tagRepository: TagRepository

    init(tagRepository: TagRepository) {
        self.tagRepository = tagRepository
    }

    func execute(tagId: Int) async throws -> Result<Void, MemoError>{
        do {
            _ = try await tagRepository.deleteTag(tagId: tagId)
            return .success(())
        } catch let error {
            ///error 맵핑 구현
            return .failure(.networkError)
        }
    }
}
