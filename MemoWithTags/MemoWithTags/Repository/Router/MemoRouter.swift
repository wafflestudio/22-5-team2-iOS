//
//  MemoRouter.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import Alamofire
import Foundation

enum MemoRouter: Router {
    case fetchMemos(content: String?, tagIds: [Int]?, dateRange: ClosedRange<Date>?, page: Int)
    case createMemo(content: String, tagIds: [Int])
    case deleteMemo(memoId: Int)
    case updateMemo(memoId: Int, content: String, tagIds: [Int])
    
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
        case let .fetchMemos(content, tagIds, dateRange, page):
            var params: [String: Any] = ["page": page]
            if let content = content {
                params["content"] = content
            }
            if let tagIds = tagIds {
                params["tagIds"] = tagIds.map { String($0) }.joined(separator: ",")
            }
            if let dateRange = dateRange {
                let formatter = ISO8601DateFormatter()
                params["startDate"] = formatter.string(from: dateRange.lowerBound)
                params["endDate"] = formatter.string(from: dateRange.upperBound)
            }
            return params
        case let .createMemo(content, tagIds):
            return ["content": content, "tagIds": tagIds]
        case let .updateMemo(_, content, tagIds):
            return ["content": content, "tagIds": tagIds]
        case .deleteMemo:
            return nil
        }
    }
}

