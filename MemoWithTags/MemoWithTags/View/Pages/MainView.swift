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
    
    var body: some View {
        NavigationView {
            ZStack {
                // 배경 색상 추가
                Color.backgroundGray
                    .ignoresSafeArea()
                
                // MemoListView 분리
                MemoListView(mainViewModel: mainViewModel)
                
                // 하단에 표시될 EditingMemoView 추가
                VStack {
                    Spacer()
                    EditingMemoView(
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
                ToolbarItem(placement: .topBarLeading) { // 중앙 정렬
                    Text("Memo with Tags")
                        .font(.headline)
                }
                ToolbarItem(placement: .topBarTrailing) {
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
}
