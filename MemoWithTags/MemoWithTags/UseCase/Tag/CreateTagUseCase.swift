//
//  CreateTagUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol CreateTagUseCase {
    func execute(name: String, color: Int) async throws -> Result<Tag, TagError>
}

class DefaultCreateTagUseCase: CreateTagUseCase {
    private let tagRepository: TagRepository

    init(tagRepository: TagRepository) {
        self.tagRepository = tagRepository
    }

    func execute(name: String, color: Int) async throws -> Result<Tag, TagError> {
        do {
            let tag = try await tagRepository.createTag(name: name, color: color)
            return .success(tag)
        } catch let error {
            ///error 맵핑 구현
            return .failure(.networkError)
        }
    }
}
