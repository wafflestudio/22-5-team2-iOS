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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Memo Content
            Text(memo.content)
                .font(Font.custom("Pretendard", size: 16))
                .foregroundColor(Color.memoTextBlack)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
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
    }
}

struct MemoView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample Tag Instances
        let sampleTags = [
            Tag(id: 1, name: "Lorem ipsum", color: "#FF9C9C"),
            Tag(id: 2, name: "dolor", color: "#FFF56F"),
            Tag(id: 3, name: "sit", color: "#A6F7EA"),
            Tag(id: 4, name: "amet", color: "#D2E8FE"),
            Tag(id: 5, name: "consectetur adipiscing elit", color: "#92EDA1"),
            Tag(id: 6, name: "sed", color: "#CCFFF7"),
            Tag(id: 7, name: "do", color: "#FFD9EC"),
            Tag(id: 8, name: "eiusmod tempor incididunt ut labore et dolore magna aliqua", color: "#B0E0E6")
        ]
        
        // Sample Memo Instance
        let sampleMemo = Memo(
            id: 1,
            content: """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
            Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
            Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
            """,
            tags: sampleTags,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // MemoView Preview
        MemoView(memo: sampleMemo)
            .padding()
            .background(Color.backgroundGray)
    }
}

