//
//  Memo.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//
import Foundation

struct Memo {
    let id: Int
    let content: String
    let tags: [Tag] // Fully constructed Tag objects
    let createdAt: Date
    let updatedAt: Date
}

struct MemoDto: Decodable {
    let id: Int
    let content: String
    let tags: [Int] // Only tag IDs returned from the server
    let createdAt: String
    let updatedAt: String

    func toMemo() -> Memo {
        let dateFormatter = ISO8601DateFormatter()
        return Memo(
            id: id,
            content: content,
            tags: tags.map { Tag(id: $0, name: "", color: 0) }, // Placeholder Tag objects
            createdAt: dateFormatter.date(from: createdAt) ?? Date(),
            updatedAt: dateFormatter.date(from: updatedAt) ?? Date()
        )
    }
}
