//
//  DeleteTagUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol DeleteTagUseCase {
    func execute(tagId: Int) async throws
}

class DefaultDeleteTagUseCase: DeleteTagUseCase {
    private let tagRepository: TagRepository

    init(tagRepository: TagRepository) {
        self.tagRepository = tagRepository
    }

    func execute(tagId: Int) async throws {
        try await tagRepository.deleteTag(tagId: tagId)
    }
}
