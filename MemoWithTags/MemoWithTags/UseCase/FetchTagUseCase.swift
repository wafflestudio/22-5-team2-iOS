//
//  FetchTagUseCase.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation

protocol FetchTagUseCase {
    func execute() async -> [Tag]
}

class DefaultFetchTagUseCase: FetchTagUseCase {
    private let tagRepository: TagRepository

    init(tagRepository: TagRepository) {
        self.tagRepository = tagRepository
    }

    func execute() async -> [Tag] {
        return await tagRepository.fetchTags()
    }
}
