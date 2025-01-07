//
//  UpdateTagUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol UpdateTagUseCase {
    func execute(tagId: Int, name: String, color: String) async -> Result<Tag, TagError>
}

class DefaultUpdateTagUseCase: UpdateTagUseCase {
    private let tagRepository: TagRepository

    init(tagRepository: TagRepository) {
        self.tagRepository = tagRepository
    }

    func execute(tagId: Int, name: String, color: String) async -> Result<Tag, TagError> {
        do {
            let tag = try await tagRepository.updateTag(tagId: tagId, name: name, color: color)
            return .success(tag)
        } catch let error as BaseError {
            return .failure(.from(baseError: error))
        } catch {
            return .failure(.unknown)
        }
    }
}
