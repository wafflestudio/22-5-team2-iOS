//
//  NetworkSession.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

import Foundation
import Alamofire

struct NetworkSession {
    static let shared: Session = {
        let interceptor = NetworkInterceptor()
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 30 // 필요에 따라 타임아웃 설정
        return Session(configuration: configuration, interceptor: interceptor)
    }()
}
