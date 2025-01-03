//
//  MemoRepository.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation
import Alamofire

protocol MemoRepository: BaseRepository {
    func fetchMemos(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?) async throws -> [Memo]
    func createMemo(content: String, tags: [Int]) async throws -> Memo
    func deleteMemo(memoId: Int) async throws
    func updateMemo(memoId: Int, content: String, tags: [Int]) async throws -> Memo
}

class DefaultMemoRepository: MemoRepository {
    ///singleton
    static let shared = DefaultMemoRepository()
    
    func fetchMemos(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?) async throws -> [Memo] {
        let response = await AF.request(MemoRouter.fetchMemos(content: content, tags: tags, dateRange: dateRange)).serializingDecodable([MemoDto].self).response
        let dto = try handleError(response: response)
        
        return dto.map { $0.toMemo() }
    }

    func createMemo(content: String, tags: [Int]) async throws -> Memo {
        let response = await AF.request(MemoRouter.createMemo(content: content, tags: tags)).serializingDecodable(MemoDto.self).response
        let dto = try handleError(response: response)
        
        return dto.toMemo()
    }

    func deleteMemo(memoId: Int) async throws {
        let response = await AF.request(MemoRouter.deleteMemo(memoId: memoId)).serializingData().response
        _ = try handleError(response: response)
    }

    func updateMemo(memoId: Int, content: String, tags: [Int]) async throws -> Memo {
        let response = await AF.request(MemoRouter.updateMemo(memoId: memoId, content: content, tags: tags)).serializingDecodable(MemoDto.self).response
        let dto = try handleError(response: response)
        
        return dto.toMemo()
    }
}
