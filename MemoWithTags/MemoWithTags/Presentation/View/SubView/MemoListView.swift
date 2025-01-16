// MemoListView.swift
// MemoWithTags

import SwiftUI

struct MemoListView: View {
    @ObservedObject var viewModel: MainViewModel
    
    @State private var stopFetching: Bool = false
    
    var body: some View {
        
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                
                GeometryReader { geometry in
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .opacity(viewModel.isLoading ? 1 : 0)
                        .onChange(of: geometry.frame(in: .named("scroll")).minY) { _, value in
                            Task {
                                if value >  0 && !viewModel.memos.isEmpty && !stopFetching {
                                    await viewModel.fetchMemos()
                                }
                            }
                        }
                }
                
                ForEachIndexed(viewModel.memos.reversed()) { index, memo in
                    // MemoView with unique id and context menu
                    MemoView(memo: memo)
                        .id(memo.id)
                        .scrollTargetLayout()
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
            .padding(.horizontal, 12)
        }
        .defaultScrollAnchor(.bottom)
        .coordinateSpace(name: "scroll")
    }
}

struct ForEachIndexed<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable, Data.Element.ID: Hashable {
    let data: Data
    let content: (Int, Data.Element) -> Content
    
    init(_ data: Data, @ViewBuilder content: @escaping (Int, Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
    
    var body: some View {
        ForEach(Array(data.enumerated()), id: \.element.id) { index, element in
            content(index, element)
        }
    }
}

