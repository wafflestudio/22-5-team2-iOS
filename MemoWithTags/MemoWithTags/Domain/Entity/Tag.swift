//
//  Tag.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//
import Foundation

struct Tag: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    var name: String
    var color: String // HEX값을 받는다.
}
