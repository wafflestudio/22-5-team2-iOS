//
//  Tag.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//
import Foundation

struct Tag: Codable {
    let id: Int
    let name: String
    let color: Int // Representing 0-359 (Hue)
}

struct TagDto: Decodable {
    let id: Int
    let name: String
    let color: Int

    func toTag() -> Tag {
        return Tag(id: id, name: name, color: color)
    }
}
