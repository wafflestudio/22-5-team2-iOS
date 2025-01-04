//
//  MemoRouter.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import Alamofire
import Foundation

enum MemoRouter: Router {
    case fetchMemos(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?)
    case createMemo(content: String, tags: [Int])
    case deleteMemo(memoId: Int)
    case updateMemo(memoId: Int, content: String, tags: [Int])
    
    var baseURL: URL {
        return URL(string: NetworkConfiguration.baseURL)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMemos:
            return .get
        case .createMemo:
            return .post
        case .deleteMemo:
            return .delete
        case .updateMemo:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .fetchMemos:
            return "/search-memo"
        case .createMemo:
            return "/memo"
        case let .deleteMemo(memoId), let .updateMemo(memoId, _, _):
            return "/memo/\(memoId)"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchMemos(content, tags, dateRange):
            var params: [String: Any] = [:]
            if let content = content {
                params["content"] = content
            }
            if let tags = tags {
                params["tags"] = tags.map { String($0) }.joined(separator: ",")
            }
            if let dateRange = dateRange {
                let formatter = ISO8601DateFormatter()
                params["startDate"] = formatter.string(from: dateRange.lowerBound)
                params["endDate"] = formatter.string(from: dateRange.upperBound)
            }
            return params
        case let .createMemo(content, tags):
            return ["content": content, "tags": tags]
        case let .updateMemo(_, content, tags):
            return ["content": content, "tags": tags]
        case .deleteMemo:
            return nil
        }
    }
}
