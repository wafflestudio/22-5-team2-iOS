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
    
    @StateObject private var keyboardResponder = KeyboardResponder() // Add this line
    
    var body: some View {
        NavigationView {
            ZStack {
                // 배경 색상 추가
                Color.backgroundGray
                    .ignoresSafeArea()
                
                MemoListView(mainViewModel: mainViewModel)
                
                EditingView(mainViewModel: mainViewModel)
                    .environmentObject(keyboardResponder)

            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
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
                if mainViewModel.tags.isEmpty {
                    mainViewModel.fetchTags()
                    print("Tags:", mainViewModel.tags)
                }
            }
        }
    }
}

