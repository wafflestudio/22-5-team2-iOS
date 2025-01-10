//
//  MainViewModel.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    @Published var memos: [Memo] = []
    @Published var memoErrorMessage: String?
    @Published var tags: [Tag] = []
    @Published var tagErrorMessage: String?
    @Published var isLoading: Bool = false
    @Published var currentMemoPage: Int = 0
    @Published var totalMemoPages: Int = 1
    
    private let createMemoUseCase: CreateMemoUseCase
    private let fetchMemoUseCase: FetchMemoUseCase
    private let updateMemoUseCase: UpdateMemoUseCase
    private let deleteMemoUseCase: DeleteMemoUseCase
    
    private let createTagUseCase: CreateTagUseCase
    private let fetchTagUseCase: FetchTagUseCase
    private let updateTagUseCase: UpdateTagUseCase
    private let deleteTagUseCase: DeleteTagUseCase
    
    init(
        createMemoUseCase: CreateMemoUseCase,
        fetchMemoUseCase: FetchMemoUseCase,
        updateMemoUseCase: UpdateMemoUseCase,
        deleteMemoUseCase: DeleteMemoUseCase,
        createTagUseCase: CreateTagUseCase,
        fetchTagUseCase: FetchTagUseCase,
        updateTagUseCase: UpdateTagUseCase,
        deleteTagUseCase: DeleteTagUseCase
    ) {
        self.createMemoUseCase = createMemoUseCase
        self.fetchMemoUseCase = fetchMemoUseCase
        self.updateMemoUseCase = updateMemoUseCase
        self.deleteMemoUseCase = deleteMemoUseCase
        self.createTagUseCase = createTagUseCase
        self.fetchTagUseCase = fetchTagUseCase
        self.updateTagUseCase = updateTagUseCase
        self.deleteTagUseCase = deleteTagUseCase
    }
    
    private func waitIfLoading() async {
        while isLoading {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1초 대기
        }
    }
    
    func fetchMemos(content: String? = nil, tags: [Int]? = nil, dateRange: ClosedRange<Date>? = nil) {
        Task {
            await waitIfLoading() // 대기 후 실행
            guard currentMemoPage < totalMemoPages else { return }
            
            isLoading = true
            let nextPage = currentMemoPage + 1
            
            let result = await fetchMemoUseCase.execute(content: content, tags: tags, dateRange: dateRange, page: nextPage)
            switch result {
            case .success(let paginatedMemos):
                self.memos.append(contentsOf: paginatedMemos.memos)
                self.currentMemoPage = paginatedMemos.currentPage
                self.totalMemoPages = paginatedMemos.totalPages
            case .failure(let error):
                self.memoErrorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    func createMemo(content: String, tags: [Int]) {
        Task {
            await waitIfLoading() // 대기 후 실행
            
            isLoading = true
            let result = await createMemoUseCase.execute(content: content, tags: tags)
            switch result {
            case .success(let newMemo):
                self.memos.insert(newMemo, at: 0)
            case .failure(let error):
                self.memoErrorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    func updateMemo(memoId: Int, newContent: String, newTags: [Int]) {
        Task {
            await waitIfLoading() // 대기 후 실행
            
            isLoading = true
            let result = await updateMemoUseCase.execute(memoId: memoId, content: newContent, tags: newTags)
            switch result {
            case .success(let updatedMemo):
                if let index = self.memos.firstIndex(where: { $0.id == memoId }) {
                    self.memos[index] = updatedMemo
                }
            case .failure(let error):
                self.memoErrorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    func deleteMemo(memoId: Int) {
        Task {
            await waitIfLoading() // 대기 후 실행
            
            isLoading = true
            let result = await deleteMemoUseCase.execute(memoId: memoId)
            switch result {
            case .success:
                self.memos.removeAll { $0.id == memoId }
            case .failure(let error):
                self.memoErrorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    func fetchTags() {
        Task {
            await waitIfLoading() // 대기 후 실행
            
            isLoading = true
            let result = await fetchTagUseCase.execute()
            print("MainViewModel - fetched Tags:", result)
            switch result {
            case .success(let fetchedTags):
                self.tags = fetchedTags
            case .failure(let error):
                self.tagErrorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    func createTag(name: String, color: String) {
        Task {
            await waitIfLoading() // 대기 후 실행
            
            isLoading = true
            let result = await createTagUseCase.execute(name: name, color: color)
            print("MainViewModel - Create Tag: ", result)
            switch result {
            case .success(let newTag):
                self.tags.append(newTag)
            case .failure(let error):
                self.tagErrorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    func updateTag(tagId: Int, newName: String, newColor: String) {
        Task {
            await waitIfLoading() // 대기 후 실행
            
            isLoading = true
            let result = await updateTagUseCase.execute(tagId: tagId, name: newName, color: newColor)
            switch result {
            case .success(let updatedTag):
                if let index = self.tags.firstIndex(where: { $0.id == tagId }) {
                    self.tags[index] = updatedTag
                }
            case .failure(let error):
                self.tagErrorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    func deleteTag(tagId: Int) {
        Task {
            await waitIfLoading() // 대기 후 실행
            
            isLoading = true
            let result = await deleteTagUseCase.execute(tagId: tagId)
            switch result {
            case .success:
                // mainViewModel의 tag 삭제
                self.tags.removeAll { $0.id == tagId }
                // mainViewModel의 memo에 있는 tag 삭제
                for index in memos.indices {
                    memos[index].tags.removeAll { $0.id == tagId }
                }
            case .failure(let error):
                self.tagErrorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    func resetMemoState() {
        self.memos = []
        self.memoErrorMessage = nil
        self.currentMemoPage = 0
        self.totalMemoPages = 1
    }
    
    func resetTagState() {
        self.tags = []
        self.tagErrorMessage = nil
    }
}
