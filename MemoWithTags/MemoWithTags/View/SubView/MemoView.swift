//
//  MemoView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import SwiftUI

struct MemoView: View {
    let memo: Memo
    @State private var collectionViewHeight: CGFloat = .zero

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 본문
            Text(memo.content)
                .font(Font.custom("Pretendard", size: 16))
                .foregroundColor(Color.memoTextBlack)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            // 태그들
            TagCollectionView(
                tags: memo.tags,
                horizontalSpacing: 9, // 수평 간격
                verticalSpacing: 7,   // 수직 간격
                collectionViewHeight: $collectionViewHeight
            )
            .frame(height: collectionViewHeight)
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
        // 샘플 Tag 인스턴스 생성
        let sampleTags = [
            Tag(id: 1, name: "이것은 엄청나게 긴 태그 이름을 자랑하는 태그", color: "#FF9C9C"),
            Tag(id: 2, name: "나는 노랭이", color: "#FFF56F"),
            Tag(id: 3, name: "나는 퍼랭이", color: "#A6F7EA"),
            Tag(id: 4, name: "SwiftUI", color: "#D2E8FE"),
            Tag(id: 5, name: "UI Design", color: "#92EDA1"),
            Tag(id: 6, name: "Development", color: "#CCFFF7"),
            Tag(id: 7, name: "Custom Tag", color: "#FFD9EC")
        ]
        
        // 샘플 Memo 인스턴스 생성
        let sampleMemo = Memo(
            id: 1,
            content: "When writing a memo, avoiding common mistakes can significantly enhance clarity and effectiveness.",
            tags: sampleTags,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // MemoView 미리보기
        MemoView(memo: sampleMemo)
            .padding()
            .background(Color.backgroundGray)
    }
}

