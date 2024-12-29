//
//  UpdateTagUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol UpdateTagUseCase {
    func execute(tagId: Int, name: String, color: Int) async throws -> Tag
}

class DefaultUpdateTagUseCase: UpdateTagUseCase {
    private let tagRepository: TagRepository

    init(tagRepository: TagRepository) {
        self.tagRepository = tagRepository
    }

    func execute(tagId: Int, name: String, color: Int) async throws -> Tag {
        return try await tagRepository.updateTag(tagId: tagId, name: name, color: color)
    }
}
