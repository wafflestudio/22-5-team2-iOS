//
//  BaseRepository.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/3/25.
//

import Foundation
import Alamofire

protocol BaseRepository {
    ///base error handiling을 위한 함수
    func handleError<T>(response: DataResponse<T, AFError>) throws
    func handleErrorDecodable<T>(response: DataResponse<T, AFError>) throws -> T
}

extension BaseRepository {
    func handleError<T>(response: DataResponse<T, AFError>) throws {
        guard let statusCode = response.response?.statusCode else {
            throw BaseError.UNKNOWN
        }
        print("status: \(statusCode)")
        
        if let error = BaseError(rawValue: statusCode) {
            throw error
        }
        if !(200...299 ~= statusCode) {
            throw BaseError.UNKNOWN
        }
    }
    
    func handleErrorDecodable<T>(response: DataResponse<T, AFError>) throws -> T {
        guard let statusCode = response.response?.statusCode else {
            throw BaseError.UNKNOWN
        }
        print("status: \(statusCode)")
        
        if let error = BaseError(rawValue: statusCode) {
            throw error
        }
        
        guard let dto = response.value else {
            throw BaseError.UNKNOWN
        }
        return dto
    }
}
