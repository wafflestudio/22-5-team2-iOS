//
//  SearchView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import SwiftUI
import Flow

struct SearchView: View {
    @ObservedObject var viewModel: MainViewModel
    
    // Timer task for debouncing
    @State private var searchTask: Task<Void, Never>? = nil
    
    var body: some View {
        ZStack {
            Color.backgroundGray
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                // Scroll view displaying search results
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        GeometryReader { geometry in
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .opacity(viewModel.isLoading ? 1 : 0)
                                .onChange(of: geometry.frame(in: .named("scroll")).minY) {_, value in
                                    Task {
                                        if value > 0 && !viewModel.searchedMemos.isEmpty {
                                            await fetchNextPage()
                                        }
                                    }
                                }
                        }
                        
                        ForEachIndexed(viewModel.searchedMemos.reversed()) { index, memo in
                            MemoView(memo: memo, viewModel: viewModel)
                                .id(memo.id)
                                .contextMenu {
                                    Button {
                                        viewModel.searchBarText = memo.content
                                    } label: {
                                        Label("비슷한 메모 검색하기", systemImage: "text.magnifyingglass")
                                    }
                                    
                                    Button(role: .destructive) {
                                        Task {
                                            await viewModel.deleteMemo(memoId: memo.id)
                                        }
                                    } label: {
                                        Label("삭제하기", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .coordinateSpace(name: "scroll")
                .defaultScrollAnchor(.bottom)
                
                HStack {
                    ForEach(viewModel.searchBarSelectedTags, id: \.id) { tag in
                        TagView(tag: tag) {
                            removeTagFromSelectedTags(tag)
                        }
                    }
                    
                    TextField("텍스트와 태그로 메모 검색", text: $viewModel.searchBarText)
                        .onChange(of: viewModel.searchBarText) {
                            // 실행하고 있는 searchTask를 종료
                            searchTask?.cancel()
                            
                            // 새로운 searchTask 생성
                            searchTask = Task {
                                // 0.5초 기다리기
                                try? await Task.sleep(nanoseconds: 500_000_000)
                                
                                await firstSearch()
                            }
                        }
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
                        }
                }
                // SearchBar internal layout
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .font(.system(size: 15, weight: .regular))
                .frame(maxWidth: .infinity)
                .background(Color.searchBarBackgroundGray)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                // SearchBar external padding
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                // Display searched tags
                HFlow {
                    ForEach(viewModel.searchedTags, id: \.id) { tag in
                        TagView(tag: tag) {
                            appendTagToSelectedTags(tag)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
            }

        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18))
                    .onTapGesture {
                        viewModel.appState.navigation.pop()
                    }
            }
        }
        .onDisappear {
            viewModel.clearSearch()
        }
    }
    
    private func removeTagFromSelectedTags(_ tag: Tag) {
        viewModel.searchBarSelectedTags.removeAll { $0.id == tag.id }
        Task {
            await firstSearch()
        }
    }
    
    private func appendTagToSelectedTags(_ tag: Tag) {
        viewModel.searchBarSelectedTags.append(tag)
        Task {
            await firstSearch()
        }
    }
    
    private func firstSearch() async {
        // 이전 검색 결과를 모두 리셋
        viewModel.searchedMemos = []
        viewModel.searchedTags = []
        viewModel.searchCurrentPage = 0
        viewModel.searchTotalPages = 1
        
        let trimmedText = viewModel.searchBarText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 검색할 text와 tag가 있는지 확인
        if !trimmedText.isEmpty || !viewModel.searchBarSelectedTags.isEmpty {
            // 선택한 tag들의 id를 뽑아서 tagId list로 만듦
            let selectedTagIds = viewModel.searchBarSelectedTags.map { $0.id }
            
            // Perform the search with content and selected tag IDs
            await viewModel.searchMemos(content: trimmedText, tagIds: selectedTagIds)
            
            // 검색창의 text에 맞는 tag를 local에서 찾아서 반환
            viewModel.searchedTags = viewModel.tags.filter { tag in
                tag.name.lowercased().contains(trimmedText.lowercased()) && !selectedTagIds.contains(tag.id)
            }
        }
    }
    
    private func fetchNextPage() async {
        let trimmedText = viewModel.searchBarText.trimmingCharacters(in: .whitespacesAndNewlines)
        let selectedTagIds = viewModel.searchBarSelectedTags.map { $0.id }
        await viewModel.searchMemos(content: trimmedText, tagIds: selectedTagIds)
    }
}
