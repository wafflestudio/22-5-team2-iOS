//
//  TagRepository.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Alamofire

protocol TagRepository {
    func fetchTags() async -> [Tag]
    func createTag(name: String, color: Int) async throws -> Tag
    func deleteTag(tagId: Int) async throws
    func updateTag(tagId: Int, name: String, color: Int) async throws -> Tag
}

class DefaultTagRepository: TagRepository {
    private let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func fetchTags() async -> [Tag] {
        let url = "\(baseURL)/tag"

        do {
            let data = try await AF.request(url, method: .get).serializingDecodable([TagDto].self).value
            return data.map { $0.toTag() }
        } catch {
            print("Failed to fetch tags: \(error)")
            return []
        }
    }

    func createTag(name: String, color: Int) async throws -> Tag {
        let url = "\(baseURL)/tag"
        let parameters: [String: Any] = [
            "name": name,
            "color": color
        ]

        let data = try await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .serializingDecodable(TagDto.self).value
        return data.toTag()
    }

    func deleteTag(tagId: Int) async throws {
        let url = "\(baseURL)/tag/\(tagId)"
        _ = try await AF.request(url, method: .delete).validate().serializingData().value
    }

    func updateTag(tagId: Int, name: String, color: Int) async throws -> Tag {
        let url = "\(baseURL)/tag/\(tagId)"
        let parameters: [String: Any] = [
            "name": name,
            "color": color
        ]

        let data = try await AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .serializingDecodable(TagDto.self).value
        return data.toTag()
    }
}
