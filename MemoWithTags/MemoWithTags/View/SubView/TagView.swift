//
//  TagView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import SwiftUI

struct TagView: View {
    let tag: Tag
    
    var body: some View {
        Text(tag.name)
            .font(Font.custom("Pretendard", size: 15))
            .foregroundColor(Color.tagTextColor)
            .padding(.horizontal, 7)
            .padding(.vertical, 1)
            .background(Color(hex: tag.color))
            .cornerRadius(4)
            .fixedSize(horizontal: true, vertical: false) // 크기를 텍스트에 고정
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        // 샘플 Tag 인스턴스 생성
        let sampleTags = [
            Tag(id: 1, name: "이것은 엄청나게 긴 태그 이름을 자랑하는 태그", color: "#FF9C9C"),
            Tag(id: 2, name: "나는 노랭이", color: "#FFF56F"),
            Tag(id: 3, name: "나는 퍼랭이", color: "#A6F7EA")
        ]
        
        VStack(spacing: 10) {
            ForEach(sampleTags, id: \.id) { tag in
                TagView(tag: tag)
            }
        }
        .padding()
        .background(Color.backgroundGray)
    }
}
