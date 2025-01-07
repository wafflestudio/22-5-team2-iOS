//
//  MemoRepository.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation
import Alamofire

protocol MemoRepository: BaseRepository {
    func fetchMemos(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?, page: Int) async throws -> PaginatedMemos
    func createMemo(content: String, tags: [Int]) async throws -> Memo
    func deleteMemo(memoId: Int) async throws
    func updateMemo(memoId: Int, content: String, tags: [Int]) async throws -> Memo
}

class DefaultMemoRepository: MemoRepository {
    /// Singleton
    static let shared = DefaultMemoRepository()
    private init() {}
    
    let tokenInterceptor = TokenInterceptor()
    
    func fetchMemos(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?, page: Int) async throws -> PaginatedMemos {
        let response = await AF.request(
            MemoRouter.fetchMemos(content: content, tags: tags, dateRange: dateRange, page: page),
            interceptor: tokenInterceptor
        ).serializingDecodable(MemoResponseDto.self).response
        
        let dto = try handleError(response: response)
        
        let memos = dto.results.map { $0.toMemo() }
        let paginatedMemos = PaginatedMemos(
            memos: memos,
            currentPage: dto.page,
            totalPages: dto.totalPages,
            totalResults: dto.totalResults
        )
        
        return paginatedMemos
    }

    func createMemo(content: String, tags: [Int]) async throws -> Memo {
        let response = await AF.request(
            MemoRouter.createMemo(content: content, tags: tags), interceptor: tokenInterceptor
        ).serializingDecodable(MemoDto.self).response
        let dto = try handleError(response: response)
        return dto.toMemo()
    }

    func deleteMemo(memoId: Int) async throws {
        let response = await AF.request(
            MemoRouter.deleteMemo(memoId: memoId), interceptor: tokenInterceptor
        ).serializingData().response
        _ = try handleError(response: response)
    }

    func updateMemo(memoId: Int, content: String, tags: [Int]) async throws -> Memo {
        let response = await AF.request(
            MemoRouter.updateMemo(memoId: memoId, content: content, tags: tags),
            interceptor: tokenInterceptor
        ).serializingDecodable(MemoDto.self).response
        let dto = try handleError(response: response)
        return dto.toMemo()
    }
}

