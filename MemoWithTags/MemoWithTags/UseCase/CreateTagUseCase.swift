//
//  CreateTagUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol CreateTagUseCase {
    func execute(name: String, color: Int) async throws -> Tag
}

class DefaultCreateTagUseCase: CreateTagUseCase {
    private let tagRepository: TagRepository

    init(tagRepository: TagRepository) {
        self.tagRepository = tagRepository
    }

    func execute(name: String, color: Int) async throws -> Tag {
        return try await tagRepository.createTag(name: name, color: color)
    }
}
