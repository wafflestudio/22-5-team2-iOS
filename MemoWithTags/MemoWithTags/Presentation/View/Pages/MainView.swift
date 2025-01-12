//
//  MainView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    @StateObject private var keyboardResponder = KeyboardResponder() // Add this line
    
    var body: some View {
        NavigationView {
            ZStack {
                // 배경 색상 추가
                Color.backgroundGray
                    .ignoresSafeArea()
                
                MemoListView(mainViewModel: viewModel)
                
                EditingView(mainViewModel: viewModel)
                    .environmentObject(keyboardResponder)

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
                                viewModel.router.push(to: .search)
                            }
                        Image(systemName: "list.bullet")
                            .font(.system(size: 15))
                            .onTapGesture {
                                viewModel.router.push(to: .settings)
                            }
                    }
                }
            }
            .onAppear {
                if viewModel.memos.isEmpty {
                    viewModel.fetchMemos()
                }
                if viewModel.tags.isEmpty {
                    viewModel.fetchTags()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
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


