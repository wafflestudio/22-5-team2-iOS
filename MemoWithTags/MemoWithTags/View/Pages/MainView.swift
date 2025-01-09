//
//  MainView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainViewModel = MainViewModel(
        createMemoUseCase: DefaultCreateMemoUseCase(memoRepository: MockMemoRepository.shared),
        fetchMemoUseCase: DefaultFetchMemoUseCase(memoRepository: MockMemoRepository.shared),
        updateMemoUseCase: DefaultUpdateMemoUseCase(memoRepository: MockMemoRepository.shared),
        deleteMemoUseCase: DefaultDeleteMemoUseCase(memoRepository: MockMemoRepository.shared),
        createTagUseCase: DefaultCreateTagUseCase(tagRepository: MockTagRepository.shared),
        fetchTagUseCase: DefaultFetchTagUseCase(tagRepository: MockTagRepository.shared),
        updateTagUseCase: DefaultUpdateTagUseCase(tagRepository: MockTagRepository.shared),
        deleteTagUseCase: DefaultDeleteTagUseCase(tagRepository: MockTagRepository.shared)
    )
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                // 배경 색상 추가
                Color.backgroundGray
                    .ignoresSafeArea()
                
                // ScrollViewReader로 ScrollView 감싸기
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(Array(mainViewModel.memos.enumerated()), id: \.element.id) { index, memo in
                                // 날짜 헤더 표시
                                if index == 0 || isDifferentDay(memo, mainViewModel.memos[index - 1]) {
                                    Text(dateFormatter.string(from: memo.createdAt))
                                        .font(Font.custom("Pretendard Variable", size: 12).weight(.medium))
                                        .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                                
                                // 각 메모에 고유한 id 부여
                                MemoView(memo: memo)
                                    .id(memo.id)
                                    .onAppear {
                                        if index == mainViewModel.memos.count - 1 {
                                            mainViewModel.fetchMemos()
                                        }
                                    }
                            }
                            
                            if mainViewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .onAppear {
                            // 뷰가 나타날 때 마지막 메모로 스크롤
                            if let lastMemo = mainViewModel.memos.last {
                                proxy.scrollTo(lastMemo.id, anchor: .bottom)
                            }
                        }
                        .onChange(of: mainViewModel.memos) { _ in
                            // 메모가 추가될 때마다 마지막 메모로 스크롤
                            if let lastMemo = mainViewModel.memos.last {
                                withAnimation {
                                    proxy.scrollTo(lastMemo.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
                // 하단에 표시될 EditingMemoView 추가
                VStack {
                    Spacer()
                    EditingMemoView(
                        memo: Memo(id: 0, content: "", tags: [], createdAt: Date(), updatedAt: Date()),
                        onConfirm: { content, tagIDs in
                            mainViewModel.createMemo(content: content, tags: tagIDs)
                        }
                    )
                    .padding(.horizontal, 7)
                    .padding(.bottom, 14)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Memo with Tags")
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        // SearchView로 이동하는 NavigationLink
                        NavigationLink(destination: SearchView()) {
                            Image(systemName: "magnifyingglass")
                        }
                        // SettingsView로 이동하는 NavigationLink
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "list.bullet")
                        }
                    }
                }
            }
            .onAppear {
                if mainViewModel.memos.isEmpty {
                    mainViewModel.fetchMemos()
                }
            }
        }
    }
    
    private func isDifferentDay(_ current: Memo, _ previous: Memo) -> Bool {
        let currentDay = Calendar.current.startOfDay(for: current.createdAt)
        let previousDay = Calendar.current.startOfDay(for: previous.createdAt)
        return currentDay != previousDay
    }
}

