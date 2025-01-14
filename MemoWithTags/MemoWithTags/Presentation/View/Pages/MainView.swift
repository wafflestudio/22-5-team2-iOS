//
//  MainView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    // KeyboardManager는 여기에서만 쓰인다.
    @StateObject private var keyboard = KeyboardManager()
    
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
                        
                        DesignTagView(text: "Tags", fontSize: 14, fontWeight: .regular, horizontalPadding: 8, verticalPadding: 3, backGroundColor: "#E3E3E7", cornerRadius: 4) {}
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
}
