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
        print("fetch memo")
        let response = await AF.request(
            MemoRouter.fetchMemos(content: content, tags: tags, dateRange: dateRange, page: page),
            interceptor: tokenInterceptor
        ).serializingDecodable(MemoResponseDto.self).response
        
        let dto = try handleErrorDecodable(response: response)
        
        let memos = dto.results.map { $0.toMemo() }
        
        // 메모가 내림차순으로 정렬되어 있는지 확인
        if !isDescendingOrder(memos: memos) {
            throw MemoError.invalidOrder
        }
        
        let paginatedMemos = PaginatedMemos(
            memos: memos,
            currentPage: dto.page,
            totalPages: dto.totalPages,
            totalResults: dto.totalResults
        )
        
        return paginatedMemos
    }
    
    private func isDescendingOrder(memos: [Memo]) -> Bool {
        guard memos.count > 1 else { return true }
        for i in 1..<memos.count {
            if memos[i].createdAt > memos[i-1].createdAt {
                return false
            }
        }
        return true
    }

    func createMemo(content: String, tags: [Int]) async throws -> Memo {
        print("create memo")
        let response = await AF.request(
            MemoRouter.createMemo(content: content, tags: tags), interceptor: tokenInterceptor
        ).serializingDecodable(MemoDto.self).response
        let dto = try handleErrorDecodable(response: response)
        return dto.toMemo()
    }

    func deleteMemo(memoId: Int) async throws {
        print("delete memo")
        let response = await AF.request(
            MemoRouter.deleteMemo(memoId: memoId), interceptor: tokenInterceptor
        ).serializingData().response
        try handleError(response: response)
    }

    func updateMemo(memoId: Int, content: String, tags: [Int]) async throws -> Memo {
        print("update memo")
        let response = await AF.request(
            MemoRouter.updateMemo(memoId: memoId, content: content, tags: tags),
            interceptor: tokenInterceptor
        ).serializingDecodable(MemoDto.self).response
        let dto = try handleErrorDecodable(response: response)
        return dto.toMemo()
    }
}

