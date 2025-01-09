//
//  MockMemoRepository.swift
//  MemoWithTagsTests
//
//  Created by Swimming Ryu on 1/10/25.
//

import Foundation

class MockMemoRepository: MemoRepository {
    
    /// Singleton
    static let shared = MockMemoRepository()
    
    // Sample Tags
    private let sampleTags: [Tag] = [
        Tag(id: 1, name: "Work", color: "#FF5733"),
        Tag(id: 2, name: "Personal", color: "#33FF57"),
        Tag(id: 3, name: "Urgent", color: "#3357FF")
    ]
    
    // Sample Memos
    private var sampleMemos: [Memo] = [
        Memo(
            id: 1,
            content: "Finish the report by Monday.",
            tags: [Tag(id: 1, name: "Work", color: "#FF5733")],
            createdAt: Date(),
            updatedAt: Date()
        ),
        Memo(
            id: 2,
            content: "Buy groceries: milk, eggs, bread.",
            tags: [Tag(id: 2, name: "Personal", color: "#33FF57")],
            createdAt: Date().addingTimeInterval(-86400),
            updatedAt: Date().addingTimeInterval(-86400)
        ),
        Memo(
            id: 3,
            content: "Call John regarding the meeting.",
            tags: [Tag(id: 1, name: "Work", color: "#FF5733"), Tag(id: 3, name: "Urgent", color: "#3357FF")],
            createdAt: Date().addingTimeInterval(-86400 * 2),
            updatedAt: Date().addingTimeInterval(-86400 * 2)
        )
    ]
    
    func fetchMemos(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?, page: Int) async throws -> PaginatedMemos {
        // Filter based on content
        var filteredMemos = sampleMemos
        if let content = content, !content.isEmpty {
            filteredMemos = filteredMemos.filter { $0.content.contains(content) }
        }
        
        // Filter based on tags
        if let tags = tags, !tags.isEmpty {
            filteredMemos = filteredMemos.filter { memo in
                !Set(tags).isDisjoint(with: memo.tags.map { $0.id })
            }
        }
        
        // Filter based on dateRange
        if let dateRange = dateRange {
            filteredMemos = filteredMemos.filter { memo in
                dateRange.contains(memo.createdAt)
            }
        }
        
        // Pagination logic (assuming page size of 10)
        let pageSize = 10
        let totalResults = filteredMemos.count
        let totalPages = max(1, Int(ceil(Double(totalResults) / Double(pageSize))))
        
        guard page <= totalPages else {
            throw MemoError.invalidOrder // Or another appropriate error
        }
        
        let startIndex = (page - 1) * pageSize
        let endIndex = min(startIndex + pageSize, totalResults)
        let paginatedMemos = Array(filteredMemos[startIndex..<endIndex])
        
        return PaginatedMemos(
            memos: paginatedMemos,
            currentPage: page,
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
    
    func createMemo(content: String, tags: [Int]) async throws -> Memo {
        let newMemo = Memo(
            id: (sampleMemos.last?.id ?? 0) + 1,
            content: content,
            tags: sampleTags.filter { tags.contains($0.id) },
            createdAt: Date(),
            updatedAt: Date()
        )
        sampleMemos.append(newMemo)
        return newMemo
    }
    
    func deleteMemo(memoId: Int) async throws {
        guard let index = sampleMemos.firstIndex(where: { $0.id == memoId }) else {
            throw MemoError.nonExistingMemo
        }
        sampleMemos.remove(at: index)
    }
    
    func updateMemo(memoId: Int, content: String, tags: [Int]) async throws -> Memo {
        guard let index = sampleMemos.firstIndex(where: { $0.id == memoId }) else {
            throw MemoError.nonExistingMemo
        }
        var updatedMemo = sampleMemos[index]
        updatedMemo.content = content
        updatedMemo.tags = sampleTags.filter { tags.contains($0.id) }
        updatedMemo.updatedAt = Date()
        sampleMemos[index] = updatedMemo
        return updatedMemo
    }
}

