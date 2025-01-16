//
//  MainView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack {
            Color.backgroundGray
                .ignoresSafeArea()
            
            //메모 리스트
            MemoListView(viewModel: viewModel)
                .border(.blue, width: 2)

            // 메모 생성 or 수정 창
            EditingMemoView(viewModel: viewModel)
            
        }
        .onAppear {
            Task {
                await viewModel.initMemo()
            }
        }
        .toolbar {
            // 로고
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 3) {
                    Text("Memo with")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.titleTextBlack)
                    
                    DesignTagView(text: "Tags", fontSize: 14, fontWeight: .regular, horizontalPadding: 8, verticalPadding: 3, backGroundColor: "#E3E3E7", cornerRadius: 4) {}
                }
            }
            
            // 서치, 설정 창 버튼
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
            

            // 키보드 바로 위 태그 리스트 창
            ToolbarItem(placement: .keyboard) {
                EditingTagListView(viewModel: viewModel)
            }

        }
        .navigationBarBackButtonHidden(true)
    }
}
