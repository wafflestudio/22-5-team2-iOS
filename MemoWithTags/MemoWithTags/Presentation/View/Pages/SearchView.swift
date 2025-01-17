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
    
    //pagination할 때는 검색어가 고정되어 있어야 하므로
    @State var submitText: String = ""
    
    var body: some View {
        ZStack {
            Color.backgroundGray
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                
                Spacer()
                
                // 검색 결과 보여주는 스크롤 뷰
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        GeometryReader { geometry in
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .opacity(viewModel.isLoading ? 1 : 0)
                                .onChange(of: geometry.frame(in: .named("scroll")).minY) { _, value in
                                    Task {
                                        if value > 0 && !viewModel.searchedMemos.isEmpty{
                                            await viewModel.searchMemos(content: submitText)
                                        }
                                    }
                                }
                        }
                        
                        ForEachIndexed(viewModel.searchedMemos.reversed()) { index, memo in
                            MemoView(memo: memo, viewModel: viewModel)
                                .id(memo.id)
                                .contextMenu {
                                    Button {
                                        // 이 텍스트 내용이 그대로 검색창으로 넘어가서 검색이 실행되어야 한다.
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
                .border(.blue, width: 2)
                .coordinateSpace(name: "scroll")
                .defaultScrollAnchor(.bottom)
                
                HStack {
                    // 검색창에 있는 메모들
                    ForEach(viewModel.searchBarSelectedTags, id: \.id) { tag in
                        TagView(tag: tag) {
                            removeTagFromSelectedTags(tag)
                        }
                    }
                    
                    TextField("텍스트와 태그로 메모 검색", text: $viewModel.searchBarText)
                        .onSubmit {
                            Task {
                                submitText = viewModel.searchBarText.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !submitText.isEmpty || !viewModel.searchBarSelectedTags.isEmpty {
                                    viewModel.searchCurrentPage = 0
                                    viewModel.searchTotalPages = 1
                                    viewModel.searchedMemos = []
                                    viewModel.searchedTags = []
                                    let selectedTagIds = viewModel.searchBarSelectedTags.map { $0.id }
                                    await viewModel.searchMemos(content: submitText, tagIds: selectedTagIds) // 여기에 viewModel.searchBarSelectedTags의 id를 넣어줘.
                                    viewModel.searchedTags = viewModel.tags.filter { tag in
                                        tag.name.lowercased().contains(submitText.lowercased()) && !selectedTagIds.contains(tag.id)
                                    }
                                }
                            }
                        }
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
                        }
                }
                // searchBar 내부 layout 결정
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .font(.system(size: 15, weight: .regular))
                .frame(maxWidth: .infinity)
                .background(Color.searchBarBackgroundGray)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                // SearchBar 외부 padding 결정
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                // 검색된 태그들
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
    }
    
    private func removeTagFromSelectedTags(_ tag: Tag) {
        viewModel.searchBarSelectedTags.removeAll { $0.id == tag.id }
    }
    
    private func appendTagToSelectedTags(_ tag: Tag) {
        viewModel.searchBarSelectedTags.append(tag)
    }

}
