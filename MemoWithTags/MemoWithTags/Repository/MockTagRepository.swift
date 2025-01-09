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
    
    // Sample Tags
    private var sampleTags: [Tag] = [
        Tag(id: 1, name: "Work", color: "#FF5733"),
        Tag(id: 2, name: "Personal", color: "#33FF57"),
        Tag(id: 3, name: "Urgent", color: "#3357FF")
    ]
    
    func fetchTags() async throws -> [Tag] {
        return sampleTags
    }
    
    func createTag(name: String, color: String) async throws -> Tag {
        let newTag = Tag(
            id: (sampleTags.last?.id ?? 0) + 1,
            name: name,
            color: color
        )
        sampleTags.append(newTag)
        return newTag
    }
    
    func deleteTag(tagId: Int) async throws {
        guard let index = sampleTags.firstIndex(where: { $0.id == tagId }) else {
            throw TagError.nonExistingMemo // Or another appropriate error
        }
        sampleTags.remove(at: index)
    }
    
    func updateTag(tagId: Int, name: String, color: String) async throws -> Tag {
        guard let index = sampleTags.firstIndex(where: { $0.id == tagId }) else {
            throw TagError.nonExistingMemo // Or another appropriate error
        }
        var updatedTag = sampleTags[index]
        updatedTag.name = name
        updatedTag.color = color
        sampleTags[index] = updatedTag
        return updatedTag
    }
}
