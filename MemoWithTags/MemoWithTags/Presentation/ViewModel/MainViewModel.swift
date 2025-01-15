//
//  MainViewModel.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import Foundation

@MainActor
final class MainViewModel: BaseViewModel, ObservableObject {
    //main 쪽
    @Published var memos: [Memo] = []
    @Published var tags: [Tag] = []
    @Published var mainCurrentPage: Int = 1
    @Published var mainTotalPages: Int = 1
    @Published var selectedTags: [Tag] = [] //메모 생성할때 추가한 태그들 보관
    
    //search 쪽
    @Published var searchText: String = ""
    @Published var selectedSearchTags: [Tag] = [] //메모 검색할때 추가한 태그들 보관
    @Published var searchedMemos: [Memo] = []
    @Published var searchedTags: [Tag] = []
    @Published var searchCurrentPage: Int = 1
    @Published var searchTotalPages: Int = 1
    
    @Published var isLoading: Bool = false
    
    func fetchMemos(content: String? = nil, tagIds: [Int]? = nil, dateRange: ClosedRange<Date>? = nil) async {
        isLoading = true
        
        var result: Result<PaginatedMemos, MemoError>
        
        if content == nil && tagIds == nil && dateRange == nil {
            guard mainCurrentPage <= mainTotalPages else {
                isLoading = false
                return
            }
            result = await useCases.fetchMemoUseCase.execute(content: content, tagIds: tagIds, dateRange: dateRange, page: mainCurrentPage)
        } else {
            guard searchCurrentPage <= searchTotalPages else {
                isLoading = false
                return
            }
            result = await useCases.fetchMemoUseCase.execute(content: content, tagIds: tagIds, dateRange: dateRange, page: searchCurrentPage)
        }

        switch result {
        case .success(let paginatedMemos):
            let updatedMemos = paginatedMemos.memos.map { memo -> Memo in
                var updatedMemo = memo
                updatedMemo.tags = getTags(from: updatedMemo.tagIds)
                return updatedMemo
            }
            
            if content == nil && tagIds == nil && dateRange == nil {
                self.memos.append(contentsOf: updatedMemos)
                self.mainTotalPages = paginatedMemos.totalPages
            } else {
                self.searchedMemos.append(contentsOf: updatedMemos)
                self.searchTotalPages = paginatedMemos.totalPages
            }

        case .failure(let error):
            appState.system.showAlert = true
            appState.system.errorMessage = error.localizedDescription()
        }
        
        isLoading = false
    }
    
    func createMemo(content: String, tagIds: [Int]) async {
        isLoading = true
        
        let result = await useCases.createMemoUseCase.execute(content: content, tagIds: tagIds)
        
        switch result {
        case .success(let memo):
            var newMemo = memo
            newMemo.tags = getTags(from: newMemo.tagIds)
            self.memos.insert(newMemo, at: 0)
        case .failure(let error):
            appState.system.showAlert = true
            appState.system.errorMessage = error.localizedDescription()
        }
        
        isLoading = false
    }
    
    func updateMemo(memoId: Int, newContent: String, newTagIds: [Int]) async {
        isLoading = true
        
        let result = await useCases.updateMemoUseCase.execute(memoId: memoId, content: newContent, tagIds: newTagIds)
        switch result {
        case .success(let memo):
            if let index = self.memos.firstIndex(where: { $0.id == memoId }) {
                self.memos[index] = memo
            }
        case .failure(let error):
            appState.system.showAlert = true
            appState.system.errorMessage = error.localizedDescription()
        }
        
        isLoading = false
    }
    
    func deleteMemo(memoId: Int) async {
        isLoading = true
        
        let result = await useCases.deleteMemoUseCase.execute(memoId: memoId)
        switch result {
        case .success:
            self.memos.removeAll { $0.id == memoId }
        case .failure(let error):
            appState.system.showAlert = true
            appState.system.errorMessage = error.localizedDescription()
        }
        
        isLoading = false
    }
    
    func fetchTags() async {
        isLoading = true
        
        let result = await useCases.fetchTagUseCase.execute()
        switch result {
        case .success(let fetchedTags):
            self.tags = fetchedTags
        case .failure(let error):
            appState.system.showAlert = true
            appState.system.errorMessage = error.localizedDescription()
        }
        
        isLoading = false
    }
    
    func createTag(name: String, color: String) async {
        isLoading = true
        
        let result = await useCases.createTagUseCase.execute(name: name, color: color)
        switch result {
        case .success(let tag):
            self.tags.append(tag)
        case .failure(let error):
            appState.system.showAlert = true
            appState.system.errorMessage = error.localizedDescription()
        }
        
        isLoading = false
    }
    
    func updateTag(tagId: Int, newName: String, newColor: String) async {
        isLoading = true
        
        let result = await useCases.updateTagUseCase.execute(tagId: tagId, name: newName, color: newColor)
        switch result {
        case .success(let tag):
            if let index = self.tags.firstIndex(where: { $0.id == tagId }) {
                self.tags[index] = tag
            }
        case .failure(let error):
            appState.system.showAlert = true
            appState.system.errorMessage = error.localizedDescription()
        }
        
        isLoading = false
    }
    
    func deleteTag(tagId: Int) async {
        isLoading = true
        
        let result = await useCases.deleteTagUseCase.execute(tagId: tagId)
        switch result {
        case .success:
            // mainViewModel의 tag 삭제
            self.tags.removeAll { $0.id == tagId }
            // mainViewModel의 memo에 있는 tag 삭제
            for index in memos.indices {
                self.memos[index].tags.removeAll { $0.id == tagId }
            }
        case .failure(let error):
            appState.system.showAlert = true
            appState.system.errorMessage = error.localizedDescription()
        }
        
        isLoading = false
    }
    
    ///main view에서 onApear때 쓰는 함수
    func initMemo() async {
        if tags.isEmpty {
            await fetchTags()
        }
        if memos.isEmpty {
            await fetchMemos()
        }
    }
    
    ///settings view에서 로그아웃하는 함수
    func logout() async {
        let result = await useCases.logoutUseCase.execute()
        
        switch result {
        case .success:
            clearVM()
            appState.user.isLoggedIn = false
            appState.navigation.reset()
            appState.navigation.push(to: .root)
        case .failure(let error):
            appState.system.showAlert = true
            appState.system.errorMessage = error.localizedDescription()
        }
    }
    
    ///태그 추천 해주는 함수
    func recommendTags() -> [Tag] {
        tags.filter { !selectedTags.contains($0) }
    }
    
    /// tag id --> tag 맵핑하는 함수
    private func getTags(from tagIDs: [Int]) -> [Tag] {
        return tags.filter { tagIDs.contains($0.id) }
    }
    
    private func clearVM() {
        memos = []
        tags = []
        selectedTags = []
        mainCurrentPage = 1
        mainTotalPages = 1
        
        searchText = ""
        searchedMemos = []
        searchedTags = []
        selectedSearchTags = []
        searchCurrentPage = 1
        searchTotalPages = 1
    }
}

