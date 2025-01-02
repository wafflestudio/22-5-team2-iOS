//
//  TagRepository.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Alamofire

protocol TagRepository {
    //
    func fetchTags() async -> Result<[Tag], TagError>
    func createTag(name: String, color: Int) async -> Result<Tag, TagError>
    func deleteTag(tagId: Int) async -> Result<Void, TagError>
    func updateTag(tagId: Int, name: String, color: Int) async -> Result<Tag, TagError>
}

enum TagError: Error {
    case networkError
    case decodingError
    case invalidParameters
    case tagNotFound
    case serverError(String)
    case unknown
}

class DefaultTagRepository: TagRepository {
    private let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func fetchTags() async -> Result<[Tag], TagError> {
        let url = "\(baseURL)/tag"

        do {
            let data = try await AF.request(url, method: .get)
                .validate()
                .serializingDecodable([TagDto].self).value
            let tags = data.map { $0.toTag() }
            return .success(tags)
        } catch let afError as AFError {
            if let responseCode = afError.responseCode {
                switch responseCode {
                case 400:
                    return .failure(.invalidParameters)
                case 404:
                    return .failure(.tagNotFound)
                case 500...599:
                    return .failure(.serverError("Server error with code \(responseCode)"))
                default:
                    return .failure(.networkError)
                }
            }
            return .failure(.networkError)
        } catch {
            return .failure(.unknown)
        }
    }

    func createTag(name: String, color: Int) async -> Result<Tag, TagError> {
        let url = "\(baseURL)/tag"
        let parameters: [String: Any] = [
            "name": name,
            "color": color
        ]

        do {
            let data = try await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .serializingDecodable(TagDto.self).value
            return .success(data.toTag())
        } catch let afError as AFError {
            if let responseCode = afError.responseCode {
                switch responseCode {
                case 400:
                    return .failure(.invalidParameters)
                case 409:
                    return .failure(.tagNotFound) // Example: Conflict if tag already exists
                case 500...599:
                    return .failure(.serverError("Server error with code \(responseCode)"))
                default:
                    return .failure(.networkError)
                }
            }
            return .failure(.networkError)
        } catch {
            return .failure(.unknown)
        }
    }

    func deleteTag(tagId: Int) async -> Result<Void, TagError> {
        let url = "\(baseURL)/tag/\(tagId)"
        
        do {
            _ = try await AF.request(url, method: .delete)
                .validate()
                .serializingData().value
            return .success(())
        } catch let afError as AFError {
            if let responseCode = afError.responseCode {
                switch responseCode {
                case 404:
                    return .failure(.tagNotFound)
                case 500...599:
                    return .failure(.serverError("Server error with code \(responseCode)"))
                default:
                    return .failure(.networkError)
                }
            }
            return .failure(.networkError)
        } catch {
            return .failure(.unknown)
        }
    }

    func updateTag(tagId: Int, name: String, color: Int) async -> Result<Tag, TagError> {
        let url = "\(baseURL)/tag/\(tagId)"
        let parameters: [String: Any] = [
            "name": name,
            "color": color
        ]

        do {
            let data = try await AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .serializingDecodable(TagDto.self).value
            return .success(data.toTag())
        } catch let afError as AFError {
            if let responseCode = afError.responseCode {
                switch responseCode {
                case 400:
                    return .failure(.invalidParameters)
                case 404:
                    return .failure(.tagNotFound)
                case 500...599:
                    return .failure(.serverError("Server error with code \(responseCode)"))
                default:
                    return .failure(.networkError)
                }
            }
            return .failure(.networkError)
        } catch {
            return .failure(.unknown)
        }
    }
}
