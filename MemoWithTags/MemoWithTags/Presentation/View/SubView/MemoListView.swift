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
                    MemoView(memo: memo, viewModel: viewModel)
                        .id(memo.id)
                        .scrollTargetLayout()
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

