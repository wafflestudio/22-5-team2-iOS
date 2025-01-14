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
    @State private var expand = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Memo Content
            Text(memo.content)
                .font(Font.custom("Pretendard", size: 16))
                .foregroundColor(Color.memoTextBlack)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .lineLimit(expand ? nil : 3)
            
            // Tags using FlowLayout
            HFlow{
                ForEach(memo.tags, id: \.id) { tag in
                    TagView(tag: tag)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(Color.memoBackgroundWhite)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                expand.toggle()
            }
        }
    }
}
