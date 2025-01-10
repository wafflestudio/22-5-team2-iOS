//
//  Memo.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//
import Foundation

struct Memo: Codable, Identifiable, Equatable  {
    let id: Int
    var content: String
    var tagIds: [Int]
    var tags: [Tag]
    var createdAt: Date
    var updatedAt: Date
}

struct MemoDto: Decodable {
    let id: Int
    let content: String
    let tagIds: [Int]
    let createdAt: String
    let updatedAt: String

    func toMemo() -> Memo {
        let dateFormatter = ISO8601DateFormatter()
        return Memo(
            id: id,
            content: content,
            tagIds: tagIds,
            tags: [],
            createdAt: dateFormatter.date(from: createdAt) ?? Date(),
            updatedAt: dateFormatter.date(from: updatedAt) ?? Date()
        )
    }
}

struct MemoResponseDto: Decodable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [MemoDto]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results
    }
}

struct PaginatedMemos {
    let memos: [Memo]
    let currentPage: Int
    let totalPages: Int
    let totalResults: Int
}

