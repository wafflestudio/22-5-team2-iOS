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
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


