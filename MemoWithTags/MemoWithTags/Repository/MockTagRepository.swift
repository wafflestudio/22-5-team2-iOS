//
//  MockTagRepository.swift
//  MemoWithTagsTests
//
//  Created by Swimming Ryu on 1/10/25.
//

import Foundation

class MockTagRepository: TagRepository {
    
    /// Singleton
    static let shared = MockTagRepository()
    
    func fetchTags() async throws -> [Tag] {
        return MockMemoRepository.shared.sampleTags
    }
    
    func createTag(name: String, color: String) async throws -> Tag {
        let newTag = Tag(
            id: (MockMemoRepository.shared.sampleTags.last?.id ?? 0) + 1,
            name: name,
            color: color
        )
        MockMemoRepository.shared.sampleTags.append(newTag)
        return newTag
    }
    
    func deleteTag(tagId: Int) async throws {
        guard let index = MockMemoRepository.shared.sampleTags.firstIndex(where: { $0.id == tagId }) else {
            throw TagError.nonExistingMemo // Or another appropriate error
        }
        MockMemoRepository.shared.sampleTags.remove(at: index)
    }
    
    func updateTag(tagId: Int, name: String, color: String) async throws -> Tag {
        guard let index = MockMemoRepository.shared.sampleTags.firstIndex(where: { $0.id == tagId }) else {
            throw TagError.nonExistingMemo // Or another appropriate error
        }
        var updatedTag = MockMemoRepository.shared.sampleTags[index]
        updatedTag.name = name
        updatedTag.color = color
        MockMemoRepository.shared.sampleTags[index] = updatedTag
        return updatedTag
    }
}
