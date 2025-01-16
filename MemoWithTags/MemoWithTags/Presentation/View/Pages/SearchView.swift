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
                            MemoView(memo: memo)
                                .id(memo.id)
                                .contextMenu {
                                    Button {
                                        // memolist에서 선택된 memo를 hide하고
                                        // EditingMemoView에 선택된 memo를 표시해야 함
                                    } label: {
                                        Label("메모 수정", systemImage: "pencil")
                                    }
                                    
                                    Button(role: .destructive) {
                                        Task {
                                            await viewModel.deleteMemo(memoId: memo.id)
                                        }

                                    } label: {
                                        Label("메모 삭제", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    
                    //검색된 태그들
                    HFlow {
                        ForEach(viewModel.searchedTags, id: \.id) { tag in
                            TagView(tag: tag) {
                                //검색된 태그 클릭했을 때 액션
                            }
                        }
                        Spacer()
                    }
                    
                }
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .border(.blue, width: 2)
                .coordinateSpace(name: "scroll")
                .defaultScrollAnchor(.bottom)
                
                HStack {
                    TextField("단어와 태그로 메모 검색", text: $viewModel.searchText)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .font(.system(size: 15, weight: .regular))
                        .frame(maxWidth: .infinity)
                        .background(Color.searchBarBackgroundGray)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .onSubmit {
                            Task {
                                submitText = viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !submitText.isEmpty {
                                    viewModel.searchCurrentPage = 0
                                    viewModel.searchTotalPages = 1
                                    viewModel.searchedMemos = []
                                    viewModel.searchedTags = []
                                    await viewModel.searchMemos(content: submitText)
                                    viewModel.searchedTags = viewModel.tags.filter { $0.name.lowercased().contains(submitText.lowercased()) }
                                }
                            }
                        }
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
                        }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
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

}
