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
                //상단 창
                HStack(spacing: 10) {
                    //뒤로가기 버튼
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18))
                        .onTapGesture {
                            viewModel.appState.navigation.pop()
                        }
                    
                    //검색 창
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
                                    viewModel.searchCurrentPage = 1
                                    viewModel.searchTotalPages = 1
                                    viewModel.searchedMemos = []
                                    await viewModel.fetchMemos(content: submitText)
                                    viewModel.searchedTags = viewModel.tags.filter { $0.name.lowercased().contains(submitText.lowercased()) }
                                }
                            }
                        }
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
                        }
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 14)
                
                // 검색 결과 보여주는 스크롤 뷰
                ScrollView {
                    //검색 내용 없을 때 기본 뷰
                    if viewModel.searchedTags.isEmpty && viewModel.searchedMemos.isEmpty {
                        
                        HFlow {
                            ForEach(viewModel.tags, id: \.id) { tag in
                                TagView(tag: tag) {
                                    
                                }
                            }
                            ForEach(viewModel.memos, id: \.id) { memo in
                                shortMemo(memo: memo)
                            }
                        }
                        
                    } else { //검색 내용 있을 때
                        //검색된 태그들
                        HFlow {
                            ForEach(viewModel.searchedTags, id: \.id) { tag in
                                TagView(tag: tag) {
                                    
                                }
                            }
                            Spacer()
                        }
                        
                        //검색된 메모들
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEachIndexed(viewModel.searchedMemos) { index, memo in
                                MemoView(memo: memo, viewModel: viewModel)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            Task {
                                                await viewModel.deleteMemo(memoId: memo.id)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .onAppear {
                                        if index == viewModel.searchedMemos.count - 1 {
                                            Task {
                                                viewModel.searchCurrentPage += 1
                                                await viewModel.fetchMemos(content: submitText)
                                            }
                                        }
                                    }
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            
                            // 100픽셀 높이의 빈 공간 추가
                            Color.clear
                                .frame(height: 100)
                                .id("bottomSpace")
                        }
                        
                    }
                    
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }

        }
        .navigationBarBackButtonHidden()
        .toolbar {
        }
    }
    
    @ViewBuilder func shortMemo(memo: Memo) -> some View {
        Text(memo.content)
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(Color.titleTextBlack)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}
