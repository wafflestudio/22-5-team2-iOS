//
//  MemoRepository.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Foundation
import Alamofire

protocol MemoRepository {
    // filter와 sort해서 결과를 보내준다. Today's Memo, Search 모두에 활용 가능하다.
    func fetchMemos(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?) async -> Result<[Memo], MemoError>
    func createMemo(content: String, tags: [Int]) async throws -> Result<Memo, MemoError>
    func deleteMemo(memoId: Int) async throws -> Result<Void, MemoError>
    func updateMemo(memoId: Int, content: String, tags: [Int]) async throws -> Result<Memo, MemoError>
}

enum MemoError: Error {
    case networkError
    case decodingError
    case invalidParameters
    case memoNotFound
    case memoAlreadyExists
    case unauthorized
    case forbidden
    case serverError(String)
    case unknown
}

final class DefaultMemoRepository: MemoRepository {
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    // Helper method to map AFError to MemoError
    private func AFErrorToMemoError(_ afError: AFError) -> MemoError {
        if let responseCode = afError.responseCode {
            switch responseCode {
            case 400:
                return .invalidParameters
            case 401:
                return .unauthorized
            case 403:
                return .forbidden
            case 404:
                return .memoNotFound
            case 409:
                return .memoAlreadyExists
            case 500...599:
                return .serverError("Server error with code \(responseCode)")
            default:
                return .networkError
            }
        }
        return .networkError
    }
    
    func fetchMemos(content: String?, tags: [Int]?, dateRange: ClosedRange<Date>?) async -> Result<[Memo], MemoError> {
        var parameters: [String: Any] = [:]
        if let content = content {
            parameters["content"] = content
        }
        if let tags = tags {
            parameters["tags"] = tags.map { String($0) }.joined(separator: ",")
        }
        if let dateRange = dateRange {
            let formatter = ISO8601DateFormatter()
            parameters["startDate"] = formatter.string(from: dateRange.lowerBound)
            parameters["endDate"] = formatter.string(from: dateRange.upperBound)
        }
        
        let url = "\(baseURL)/search-memo"
        
        do {
            let data = try await AF.request(url, method: .get, parameters: parameters)
                .validate()
                .serializingDecodable([MemoDto].self).value
            let memos = data.map { $0.toMemo() }.sorted(by: { $0.createdAt < $1.createdAt })
            return .success(memos)
        } catch let decodingError as DecodingError {
            print("Decoding error in fetchMemos: \(decodingError)")
            return .failure(.decodingError)
        } catch let afError as AFError {
            print("AFError in fetchMemos: \(afError)")
            return .failure(AFErrorToMemoError(afError))
        } catch {
            print("Unknown error in fetchMemos: \(error)")
            return .failure(.unknown)
        }
    }
    
    func createMemo(content: String, tags: [Int]) async -> Result<Memo, MemoError> {
        let url = "\(baseURL)/memo"
        let parameters: [String: Any] = [
            "content": content,
            "tags": tags
        ]
        
        do {
            let data = try await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .serializingDecodable(MemoDto.self).value
            return .success(data.toMemo())
        } catch let decodingError as DecodingError {
            print("Decoding error in createMemo: \(decodingError)")
            return .failure(.decodingError)
        } catch let afError as AFError {
            print("AFError in createMemo: \(afError)")
            return .failure(AFErrorToMemoError(afError))
        } catch {
            print("Unknown error in createMemo: \(error)")
            return .failure(.unknown)
        }
    }
    
    func deleteMemo(memoId: Int) async -> Result<Void, MemoError> {
        let url = "\(baseURL)/memo/\(memoId)"
        
        do {
            _ = try await AF.request(url, method: .delete)
                .validate()
                .serializingData().value
            return .success(())
        } catch let afError as AFError {
            print("AFError in deleteMemo: \(afError)")
            return .failure(AFErrorToMemoError(afError))
        } catch {
            print("Unknown error in deleteMemo: \(error)")
            return .failure(.unknown)
        }
    }
    
    func updateMemo(memoId: Int, content: String, tags: [Int]) async -> Result<Memo, MemoError> {
        let url = "\(baseURL)/memo/\(memoId)"
        let parameters: [String: Any] = [
            "content": content,
            "tags": tags
        ]
        
        do {
            let data = try await AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .serializingDecodable(MemoDto.self).value
            return .success(data.toMemo())
        } catch let decodingError as DecodingError {
            print("Decoding error in updateMemo: \(decodingError)")
            return .failure(.decodingError)
        } catch let afError as AFError {
            print("AFError in updateMemo: \(afError)")
            return .failure(AFErrorToMemoError(afError))
        } catch {
            print("Unknown error in updateMemo: \(error)")
            return .failure(.unknown)
        }
    }
}
