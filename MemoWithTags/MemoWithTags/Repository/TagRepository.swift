//
//  TagRepository.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/29/24.
//

import Alamofire

protocol TagRepository: BaseRepository {
    func fetchTags() async throws -> [Tag]
    func createTag(name: String, color: Int) async throws -> Tag
    func deleteTag(tagId: Int) async throws
    func updateTag(tagId: Int, name: String, color: Int) async throws -> Tag
}

class DefaultTagRepository: TagRepository {
    ///singleton
    static let shared = DefaultTagRepository()
    private init() {}
    
    func fetchTags() async throws -> [Tag] {
        let response = await AF.request(TagRouter.fetchTags).serializingDecodable([TagDto].self).response
        let dto = try handleError(response: response)
        
        return dto.map { $0.toTag() }
    }

    func createTag(name: String, color: Int) async throws -> Tag {
        let response = await AF.request(TagRouter.createTag(name: name, color: color)).serializingDecodable(TagDto.self).response
        let dto = try handleError(response: response)
        
        return dto.toTag()
    }

    func deleteTag(tagId: Int) async throws {
        let response =  await AF.request(TagRouter.deleteTag(tagId: tagId)).serializingData().response
        _ = try handleError(response: response)
    }

    func updateTag(tagId: Int, name: String, color: Int) async throws -> Tag {
        let response = await AF.request(TagRouter.updateTag(tagId: tagId, name: name, color: color)).serializingDecodable(TagDto.self).response
        let dto = try handleError(response: response)
        
        return dto.toTag()
    }
}
