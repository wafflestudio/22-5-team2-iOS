/*

// MemoListView.swift
// MemoWithTags

import SwiftUI

struct MemoListView: View {
    @ObservedObject var viewModel: MainViewModel
    
    @State private var canFetch: Bool = false
    @State private var scrollToId: Int? = nil
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    // 이제 viewModel.memos는 가장 최신 memo가 list의 가장 뒤에 온다.
                    ForEach(viewModel.memos) { memo in
                        MemoView(memo: memo, viewModel: viewModel)
                            .id(memo.id)
                            .onAppear {
                                // swift 구조상 새로운 memo가 fetch되어 viewModel.memos의 앞부분에 insert되면
                                // 모든 memoView가 그려지고 swift가 강제로 scrollView의 가장 위로 자동 스크롤 된다. (ㅅㅂ)
                                if memo.id == viewModel.memos.first?.id {
                                    // viewModel.memos의 첫 memo인데 canFetch라는 것은,
                                    // 사용자가 자연스럽게 scroll해서 이전 memo를 fetch하고 싶어하는 상황이다.
                                    if canFetch {
                                        canFetch = false
                                        scrollToId = memo.id
                                        print("Another Scrolling", scrollToId!)
                                        Task {
                                            await viewModel.fetchMemos()
                                        }
                                    // viewModel.memos의 첫 memo인데 !canFetch라는 것은,
                                    // 새로운 memo가 fetch되어 swift가 강제로 scrollView의 가장 위로 자동 스크롤 되어 보이는 상황이다.
                                    } else {
                                        guard let id = scrollToId else { return }
                                        DispatchQueue.main.async {
                                            usleep(10_000)
                                            scrollViewProxy.scrollTo(id, anchor: .zero)
                                            print("done Another Scrolling", id)
                                            canFetch = true
                                        }
                                    }
                                    // 왜 .onChange(of: viewModel.memos)를 안 쓰고 저렇게 하냐면,
                                    // viewModel.memos가 변한다고 해서 모든 memoView가 load된 것이 아니기 때문에 오작동이 잘 된다.
                                }
                            }
                    }
                }
                .padding(.horizontal, 12)
            }
            .onAppear {
                guard viewModel.memos.isEmpty else { return }
                Task {
                    await viewModel.fetchMemos()
                    // 첫 fetch할 때 가장 아래로 스크롤
                    if let lastMemo = viewModel.memos.last {
                        print("initial Scrolling", lastMemo)
                        DispatchQueue.main.async {
                            scrollViewProxy.scrollTo(lastMemo.id, anchor: .bottom)
                            print("done initial Scrolling", lastMemo)
                            canFetch = true
                        }
                    }
                }
            }
        }
    }
}
 
*/

// MemoListView.swift
// MemoWithTags

import SwiftUI

struct MemoListView: View {
    @ObservedObject var viewModel: MainViewModel
    
    @State private var canFetch: Bool = false
    @State private var scrollToId: Int? = nil
    @State private var disableScroll: Bool = false
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    // 이제 viewModel.memos는 가장 최신 memo가 list의 가장 뒤에 온다.
                    ForEach(viewModel.memos) { memo in
                        MemoView(memo: memo, viewModel: viewModel)
                            .id(memo.id)
                            .onAppear {
                                // swift 구조상 새로운 memo가 fetch되어 viewModel.memos의 앞부분에 insert되면
                                // 모든 memoView가 그려지고 swift가 강제로 scrollView의 가장 위로 자동 스크롤 된다. (ㅅㅂ)
                                if memo.id == viewModel.memos[1].id {
                                    // viewModel.memos의 첫 memo인데 canFetch라는 것은,
                                    // 사용자가 자연스럽게 scroll해서 이전 memo를 fetch하고 싶어하는 상황이다.
                                    // 모든 memo가 fetch 되어있으면 disableScroll을 하면 안된다.
                                    if canFetch && viewModel.mainCurrentPage != viewModel.mainTotalPages {
                                        canFetch = false
                                        scrollToId = memo.id
                                        disableScroll = true
                                        print("Another Scrolling", scrollToId!)
                                        Task {
                                            await viewModel.fetchMemos()
                                        }
                                    // viewModel.memos의 첫 memo인데 !canFetch라는 것은,
                                    // 새로운 memo가 fetch되어 swift가 강제로 scrollView의 가장 위로 자동 스크롤 되어 보이는 상황이다.
                                    } else if !canFetch {
                                        guard let id = scrollToId else { return }
                                        DispatchQueue.main.async {
                                            usleep(10_000)
                                            scrollViewProxy.scrollTo(id, anchor: .zero)
                                            print("done Another Scrolling", id)
                                            canFetch = true
                                            disableScroll = false
                                        }
                                    }
                                    // 왜 .onChange(of: viewModel.memos)를 안 쓰고 저렇게 하냐면,
                                    // viewModel.memos가 변한다고 해서 모든 memoView가 load된 것이 아니기 때문에 오작동이 잘 된다.
                                }
                            }
                    }
                }
                .padding(.horizontal, 12)
            }
            // 사용자가 계속 Tap한 상태에서 scroll하면 scrollTo가 무시되기 때문에 잠시 멈춰야 한다.
            .disabled(disableScroll)
            .onAppear {
                guard viewModel.memos.isEmpty else { return }
                Task {
                    await viewModel.fetchMemos()
                    // 첫 fetch할 때 가장 아래로 스크롤
                    if let lastMemo = viewModel.memos.last {
                        print("initial Scrolling", lastMemo)
                        DispatchQueue.main.async {
                            scrollViewProxy.scrollTo(lastMemo.id, anchor: .bottom)
                            print("done initial Scrolling", lastMemo)
                            canFetch = true
                        }
                    }
                }
            }
        }
    }
}
