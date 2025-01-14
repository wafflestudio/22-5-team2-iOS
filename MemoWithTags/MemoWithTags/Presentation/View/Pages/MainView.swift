//
//  MainView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    @StateObject private var keyboard = KeyboardState()
    
    @State private var selectedTags: [Tag] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGray
                    .ignoresSafeArea()
                
                //메모 리스트
                MemoListView(viewModel: viewModel)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    //메모 생성 창
                    EditingMemoView(viewModel: viewModel, selectedTags: $selectedTags)
                        .padding(.horizontal, 7)
                        .padding(.bottom, 14)
                    
                    //태그 생성 창
                    if keyboard.currentHeight > 0 {
                        EditingTagListView(viewModel: viewModel, recommendedTags: recommendTags(), selectedTags: $selectedTags)
                    }
           
                }

            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 3) {
                        Text("Memo with")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Color.titleTextBlack)
                        Tag(text: "Tags", size: 14, color: Color(hex: "#E3E3E7")) {}
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 14) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 15))
                            .onTapGesture {
                                viewModel.appState.navigation.push(to: .search)
                            }
                        Image(systemName: "list.bullet")
                            .font(.system(size: 15))
                            .onTapGesture {
                                viewModel.appState.navigation.push(to: .settings)
                            }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.initMemo()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func recommendTags() -> [Tag] {
        viewModel.tags.filter { !selectedTags.contains($0) }
    }
    
    // 앱 제목에 있는 태그용
    @ViewBuilder private func Tag(text: String, size: CGFloat, color: Color, onClink: @escaping () -> Void) -> some View {
        Text(text)
            .font(.system(size: size, weight: .regular))
            .foregroundStyle(Color.tagTextColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color)
            .cornerRadius(4)
            .onTapGesture {
                onClink()
            }
    }
}


