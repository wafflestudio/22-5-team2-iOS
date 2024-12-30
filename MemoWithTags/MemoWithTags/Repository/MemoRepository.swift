//
//  MemoRepository.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation
import Alamofire

protocol MemoRepository {
    func fetchMemos(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?) async -> [Memo]
    func createMemo(content: String, tags: [Int]) async throws -> Memo
    func deleteMemo(memoId: Int) async throws
    func updateMemo(memoId: Int, content: String, tags: [Int]) async throws -> Memo
}

class DefaultMemoRepository: MemoRepository {
    private let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func fetchMemos(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?) async -> [Memo] {
        var parameters: [String: Any] = [:]
        if let content = content {
            parameters["content"] = content
        }
        if let tags = tags {
            parameters["tags"] = tags.map { String($0) }.joined(separator: ",")
        }
        if let dateRange = dateRange {
            parameters["startDate"] = ISO8601DateFormatter().string(from: dateRange.lowerBound)
            parameters["endDate"] = ISO8601DateFormatter().string(from: dateRange.upperBound)
        }

        let url = "\(baseURL)/search-memo"

        do {
            let data = try await AF.request(url, method: .get, parameters: parameters).serializingDecodable([MemoDto].self).value
            return data.map { $0.toMemo() }.sorted(by: { $0.createdAt < $1.createdAt })
        } catch {
            print("Failed to fetch memos: \(error)")
            return []
        }
    }

    func createMemo(content: String, tags: [Int]) async throws -> Memo {
        let url = "\(baseURL)/memo"
        let parameters: [String: Any] = [
            "content": content,
            "tags": tags
        ]

        let data = try await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .serializingDecodable(MemoDto.self).value
        return data.toMemo()
    }

    func deleteMemo(memoId: Int) async throws {
        let url = "\(baseURL)/memo/\(memoId)"
        _ = try await AF.request(url, method: .delete).validate().serializingData().value
    }

    func updateMemo(memoId: Int, content: String, tags: [Int]) async throws -> Memo {
        let url = "\(baseURL)/memo/\(memoId)"
        let parameters: [String: Any] = [
            "content": content,
            "tags": tags
        ]

        let data = try await AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .serializingDecodable(MemoDto.self).value
        return data.toMemo()
    }
}
