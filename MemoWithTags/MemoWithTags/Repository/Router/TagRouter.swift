//
//  TagRouter.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import Foundation
import Alamofire

enum TagRouter: Router {
    case fetchTags
    case createTag(name: String, color: String)
    case deleteTag(tagId: Int)
    case updateTag(tagId: Int, name: String, color: String)
    
    var baseURL: URL {
        return URL(string: NetworkConfiguration.baseURL)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchTags:
            return .get
        case .createTag:
            return .post
        case .deleteTag:
            return .delete
        case .updateTag:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .fetchTags:
            return "/tag"
        case .createTag:
            return "/tag"
        case let .deleteTag(tagId):
            return "/tag/\(tagId)"
        case let .updateTag(tagId, _,_):
            return "/tag/\(tagId)"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchTags:
            return nil
        case let .createTag(name, color):
            return ["name": name, "color": color]
        case .deleteTag:
            return nil
        case let .updateTag(_, name, color):
            return ["name": name, "color": color]
        }
    }
}
