//
//  MemoView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import SwiftUI
import Flow

struct MemoView: View {
    let memo: Memo
    let lineLimit: Int = 3
    
    @ObservedObject var viewModel: MainViewModel
    @State private var canExpand: Bool = false
    @State private var isExpanded: Bool = false
    @State private var currentlyLocked = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            // Memo Content
            // Memo가 lock이면 반투명 막을 위에 ZStack을 씌우고, faceID를 통과해야 반투명 막을 제거해주기
            Text(memo.content)
                .background(calculateTruncation())
                .font(Font.custom("Pretendard", size: 16))
                .foregroundColor(Color.memoTextBlack)
                .lineLimit(isExpanded ? nil : lineLimit)
                .blur(radius: currentlyLocked ? 6 : 0)
                .animation(.spring, value: isExpanded)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            // Tags
            HFlow{
                ForEach(memo.tags, id: \.id) { tag in
                    TagView(tag: tag) // contect menu로, magnfuing glass 아이콘에 "이 태그로 검색하기"를 선택할 수 있다. 꾹 누르면 searchPage로 navigate되고, viewModel.searchBarSelectedTags에 그 tag가 추가된다.
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // size 줄이는 아이콘
            if canExpand && isExpanded {
                Button(action: {
                    withAnimation(.spring) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: "chevron.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(Color.memoBackgroundWhite)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
        .onAppear {
            currentlyLocked = memo.locked
        }
        .onChange(of: memo.locked) { newValue in
            currentlyLocked = newValue
        }
        .onTapGesture {
            if currentlyLocked {
                Task {
                    let authenticated = await AuthenticationManager.shared.authenticateUser(reason: "잠김 메모를 확인하려면 인증이 필요합니다.")
                    if authenticated {
                        withAnimation(.spring()) {
                            currentlyLocked = false
                        }
                    }
                }
            } else if !canExpand || isExpanded {
                viewModel.isUpdating = true
                viewModel.updatingMemoId = memo.id
                viewModel.editingMemoContent = memo.content
                viewModel.editingMemoSelectedTags = memo.tags
                viewModel.updatingMemoIsLocked = memo.locked
            } else {
                withAnimation(.spring) {
                    isExpanded.toggle()
                }
            }
        }
    }
    
    private func calculateTruncation() -> some View {
        let singleLineHeight = 20 // font size 16이 line height 20을 차지할 것이라 가정.
        let maxHeight = CGFloat(lineLimit * singleLineHeight)
        
        // ViewThatFits는 {} 안의 View 중에 보여줄 수 있는 View를 골라서 보여주는 View다.
        // Text를 세 줄 안에 보여줄 수 있으면, canExpand는 false일 것이다. (기본값)
        // 그렇지 않으면, Color.clear가 보일 것이고, canExpand는 true일 것이다.
        return ViewThatFits {
            Text(memo.content)
                .font(Font.custom("Pretendard", size: 16))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .hidden()
            
            Color.clear
                .onAppear {
                    canExpand = true
                }
                .hidden()
        }
        .frame(height: maxHeight)
    }
}
