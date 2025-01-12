//
//  MainViewModel.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import Foundation

@MainActor
final class MainViewModel: BaseViewModel, ObservableObject {
    @Published var memos: [Memo] = []
    @Published var tags: [Tag] = []
    @Published var isLoading: Bool = false
    @Published var currentMemoPage: Int = 0
    @Published var totalMemoPages: Int = 1
    
    private func waitIfLoading() async {
        while isLoading {
            try? await Task.sleep(nanoseconds: 1000_000_000) //1초 대기
        }
    }
    
    func fetchMemos(content: String? = nil, tagIds: [Int]? = nil, dateRange: ClosedRange<Date>? = nil) {
        Task {
            isLoading = true
            
            await waitIfLoading() // 대기 후 실행
            guard currentMemoPage < totalMemoPages else { return }
            
            let nextPage = currentMemoPage + 1
            
            let result = await useCases.fetchMemoUseCase.execute(content: content, tagIds: tagIds, dateRange: dateRange, page: nextPage)
            
            switch result {
            case .success(let paginatedMemos):
                let updatedMemos = paginatedMemos.memos.map { memo -> Memo in
                    var updatedMemo = memo
                    updatedMemo.tags = getTags(from: updatedMemo.tagIds)
                    return updatedMemo
                }
                self.memos.append(contentsOf: updatedMemos)
                self.currentMemoPage = paginatedMemos.currentPage
                self.totalMemoPages = paginatedMemos.totalPages
            case .failure(let error):
                appState.system.isShowingAlert = true
                appState.system.errorMessage = error.localizedDescription()
            }
            
            isLoading = false
        }
    }
    
    func createMemo(content: String, tagIds: [Int]) {
        Task {
            isLoading = true
            
            let result = await useCases.createMemoUseCase.execute(content: content, tagIds: tagIds)
            
            switch result {
            case .success(let memo):
                var newMemo = memo
                newMemo.tags = getTags(from: newMemo.tagIds)
                self.memos.insert(newMemo, at: 0)
            case .failure(let error):
                appState.system.isShowingAlert = true
                appState.system.errorMessage = error.localizedDescription()
            }
            
            isLoading = false
        }
    }
    
    func updateMemo(memoId: Int, newContent: String, newTagIds: [Int]) {
        Task {
            isLoading = true
            
            let result = await useCases.updateMemoUseCase.execute(memoId: memoId, content: newContent, tagIds: newTagIds)
            switch result {
            case .success(let memo):
                if let index = self.memos.firstIndex(where: { $0.id == memoId }) {
                    self.memos[index] = memo
                }
            case .failure(let error):
                appState.system.isShowingAlert = true
                appState.system.errorMessage = error.localizedDescription()
            }
            
            isLoading = false
        }
    }
    
    func deleteMemo(memoId: Int) {
        Task {
            isLoading = true
            
            let result = await useCases.deleteMemoUseCase.execute(memoId: memoId)
            switch result {
            case .success:
                self.memos.removeAll { $0.id == memoId }
            case .failure(let error):
                appState.system.isShowingAlert = true
                appState.system.errorMessage = error.localizedDescription()
            }
            
            isLoading = false
        }
    }
    
    func fetchTags() {
        Task {
            isLoading = true
            
            let result = await useCases.fetchTagUseCase.execute()
            switch result {
            case .success(let fetchedTags):
                self.tags = fetchedTags
            case .failure(let error):
                appState.system.isShowingAlert = true
                appState.system.errorMessage = error.localizedDescription()
            }
            
            isLoading = false
        }
    }
    
    func createTag(name: String, color: String) {
        Task {
            isLoading = true
            
            let result = await useCases.createTagUseCase.execute(name: name, color: color)
            switch result {
            case .success(let tag):
                self.tags.append(tag)
            case .failure(let error):
                appState.system.isShowingAlert = true
                appState.system.errorMessage = error.localizedDescription()
            }
            
            isLoading = false
        }
    }
    
    func updateTag(tagId: Int, newName: String, newColor: String) {
        Task {
            isLoading = true
            
            let result = await useCases.updateTagUseCase.execute(tagId: tagId, name: newName, color: newColor)
            switch result {
            case .success(let tag):
                if let index = self.tags.firstIndex(where: { $0.id == tagId }) {
                    self.tags[index] = tag
                }
            case .failure(let error):
                appState.system.isShowingAlert = true
                appState.system.errorMessage = error.localizedDescription()
            }
            
            isLoading = false
        }
    }
    
    func deleteTag(tagId: Int) {
        Task {
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
                appState.system.isShowingAlert = true
                appState.system.errorMessage = error.localizedDescription()
            }
            
            isLoading = false
        }
    }
    
    func resetMemoState() {
        self.memos = []
        self.currentMemoPage = 0
        self.totalMemoPages = 1
    }
    
    func resetTagState() {
        self.tags = []
    }
    
    /// 주어진 tagIDs를 기반으로 Tag 객체들을 반환합니다.
    private func getTags(from tagIDs: [Int]) -> [Tag] {
        return tags.filter { tagIDs.contains($0.id) }
    }
}

