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
    
    private func calculateTruncation() -> some View {
        // font size 16이 line size 20을 차지할 것이라 가정.
        let maxHeight = CGFloat(lineLimit * 20)
        
        // ViewThatFits는 {} 안의 View 중에 보여줄 수 있는 View를 골라서 보여주는 View다.
        // Text를 세 줄 안에 보여줄 수 있으면, canExpand는 false일 것이다. (기본값)
        // 그렇지 않으면, Color.clear가 보일 것이고, canExpand는 true일 것이다.
        return ViewThatFits {
            Text(memo.content)
                .font(Font.custom("Pretendard", size: 16))
                .onAppear {
                    print("can not expand")
                }
                .hidden()
            
            Color.clear
                .onAppear {
                    print("can expand")
                    canExpand = true
                }
                .hidden()
        }
        .frame(height: maxHeight)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            // Memo Content
            Text(memo.content)
                .background(calculateTruncation())
                .font(Font.custom("Pretendard", size: 16))
                .foregroundColor(Color.memoTextBlack)
                .lineLimit(isExpanded ? nil : lineLimit)
                .animation(.spring, value: isExpanded)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            // Tags
            HFlow{
                ForEach(memo.tags, id: \.id) { tag in
                    TagView(tag: tag)
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
        .onTapGesture {
            if !canExpand || isExpanded {
                viewModel.isCreating = false
                viewModel.workingMemo = memo
            } else {
                withAnimation(.spring) {
                    isExpanded.toggle()
                }
            }
        }
    }
}
