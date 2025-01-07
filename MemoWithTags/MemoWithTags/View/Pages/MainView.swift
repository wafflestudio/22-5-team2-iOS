//
//  MainView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainViewModel = MainViewModel(
        createMemoUseCase: DefaultCreateMemoUseCase(memoRepository: DefaultMemoRepository.shared),
        fetchMemoUseCase: DefaultFetchMemoUseCase(memoRepository: DefaultMemoRepository.shared),
        updateMemoUseCase: DefaultUpdateMemoUseCase(memoRepository: DefaultMemoRepository.shared),
        deleteMemoUseCase: DefaultDeleteMemoUseCase(memoRepository: DefaultMemoRepository.shared),
        createTagUseCase: DefaultCreateTagUseCase(tagRepository: DefaultTagRepository.shared),
        fetchTagUseCase: DefaultFetchTagUseCase(tagRepository: DefaultTagRepository.shared),
        updateTagUseCase: DefaultUpdateTagUseCase(tagRepository: DefaultTagRepository.shared),
        deleteTagUseCase: DefaultDeleteTagUseCase(tagRepository: DefaultTagRepository.shared)
    )
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                // 메모 리스트 ScrollView
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(mainViewModel.memos.reversed().enumerated()), id: \.element.id) { index, memo in
                            if index == 0 || isDifferentDay(memo, mainViewModel.memos.reversed()[index - 1]) {
                                Text(dateFormatter.string(from: memo.createdAt))
                                    .font(Font.custom("Pretendard Variable", size: 12).weight(.medium))
                                    .foregroundColor(Color(red: 0.63, green: 0.63, blue: 0.63))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            MemoView(memo: memo)
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
                    .padding(.bottom, 36)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Memo with Tags")
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button {
                            // Search action
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        Button {
                            // List action
                        } label: {
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

