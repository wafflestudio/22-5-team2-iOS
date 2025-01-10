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
    var sampleTags: [Tag] = [
        Tag(id: 1, name: "Work", color: "#FF5733"),
        Tag(id: 2, name: "Personal", color: "#33FF57"),
        Tag(id: 3, name: "Urgent", color: "#3357FF")
    ]
    
    // Sample Memos
    private var sampleMemos: [Memo] = [
        // Memo 1
        Memo(
            id: 1,
            content: "Finish the report by Monday.",
            tags: [Tag(id: 1, name: "Work", color: "#FF5733")],
            createdAt: Date(),
            updatedAt: Date()
        ),
        // Memo 2
        Memo(
            id: 2,
            content: "Buy groceries: milk, eggs, bread.",
            tags: [Tag(id: 2, name: "Personal", color: "#33FF57")],
            createdAt: Date().addingTimeInterval(-86400),
            updatedAt: Date().addingTimeInterval(-86400)
        ),
        // Memo 3
        Memo(
            id: 3,
            content: "Call John regarding the meeting.",
            tags: [Tag(id: 1, name: "Work", color: "#FF5733"), Tag(id: 3, name: "Urgent", color: "#3357FF")],
            createdAt: Date().addingTimeInterval(-86400 * 2),
            updatedAt: Date().addingTimeInterval(-86400 * 2)
        ),
        // Memo 4
        Memo(
            id: 4,
            content: "Schedule dentist appointment.",
            tags: [Tag(id: 2, name: "Personal", color: "#33FF57")],
            createdAt: Date().addingTimeInterval(-86400 * 3),
            updatedAt: Date().addingTimeInterval(-86400 * 3)
        ),
        // Memo 5
        Memo(
            id: 5,
            content: "Prepare slides for the presentation.",
            tags: [Tag(id: 1, name: "Work", color: "#FF5733")],
            createdAt: Date().addingTimeInterval(-86400 * 4),
            updatedAt: Date().addingTimeInterval(-86400 * 4)
        ),
        // Memo 6
        Memo(
            id: 6,
            content: "Read the new book on SwiftUI.",
            tags: [Tag(id: 2, name: "Personal", color: "#33FF57")],
            createdAt: Date().addingTimeInterval(-86400 * 5),
            updatedAt: Date().addingTimeInterval(-86400 * 5)
        ),
        // Memo 7
        Memo(
            id: 7,
            content: "Respond to the client emails.",
            tags: [Tag(id: 1, name: "Work", color: "#FF5733"), Tag(id: 3, name: "Urgent", color: "#3357FF")],
            createdAt: Date().addingTimeInterval(-86400 * 6),
            updatedAt: Date().addingTimeInterval(-86400 * 6)
        ),
        // Memo 8
        Memo(
            id: 8,
            content: "Plan weekend hiking trip.",
            tags: [Tag(id: 2, name: "Personal", color: "#33FF57")],
            createdAt: Date().addingTimeInterval(-86400 * 7),
            updatedAt: Date().addingTimeInterval(-86400 * 7)
        ),
        // Memo 9
        Memo(
            id: 9,
            content: "Update the project roadmap.",
            tags: [Tag(id: 1, name: "Work", color: "#FF5733")],
            createdAt: Date().addingTimeInterval(-86400 * 8),
            updatedAt: Date().addingTimeInterval(-86400 * 8)
        ),
        // Memo 10
        Memo(
            id: 10,
            content: "Organize the office files.",
            tags: [Tag(id: 1, name: "Work", color: "#FF5733")],
            createdAt: Date().addingTimeInterval(-86400 * 9),
            updatedAt: Date().addingTimeInterval(-86400 * 9)
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
        
        /*
        // 디버깅
        print(filteredMemos)
         */
        
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

