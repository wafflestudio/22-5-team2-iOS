//
//  Tag.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/12/25.
//

import Foundation

struct TagDto: Decodable {
    let id: Int
    let name: String
    let color: String

    func toTag() -> Tag {
        return Tag(id: id, name: name, color: color)
    }
}
