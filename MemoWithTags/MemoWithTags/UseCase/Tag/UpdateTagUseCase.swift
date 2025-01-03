//
//  UpdateTagUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol UpdateTagUseCase {
    func execute(tagId: Int, name: String, color: Int) async throws -> Result<Tag, MemoError>
}

class DefaultUpdateTagUseCase: UpdateTagUseCase {
    private let tagRepository: TagRepository

    init(tagRepository: TagRepository) {
        self.tagRepository = tagRepository
    }

    func execute(tagId: Int, name: String, color: Int) async throws -> Result<Tag, MemoError> {
        do {
            let tag = try await tagRepository.updateTag(tagId: tagId, name: name, color: color)
            return .success(tag)
        } catch let error {
            ///error 맵핑 구현
            return .failure(.networkError)
        }
    }
}
