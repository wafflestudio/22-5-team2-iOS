//
//  FetchTagUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol FetchTagUseCase {
    func execute() async -> Result<[Tag], TagError>
}

class DefaultFetchTagUseCase: FetchTagUseCase {
    private let tagRepository: TagRepository

    init(tagRepository: TagRepository) {
        self.tagRepository = tagRepository
    }

    func execute() async -> Result<[Tag], TagError>{
        do {
            let tags = try await tagRepository.fetchTags()
            return .success(tags)
        } catch let error as BaseError {
            return .failure(.from(baseError: error))
        } catch {
            return .failure(.unknown)
        }
    }
}
