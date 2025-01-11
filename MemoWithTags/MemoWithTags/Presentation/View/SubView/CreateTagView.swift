//
//  CreateTagView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/10/25.
//

import SwiftUI

struct CreateTagView: View {
    @Binding var searchText: String
    @Binding var randomColor: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Text("Create")
                .font(.custom("Pretendard", size: 16))
            
            TagView(tag: Tag(id: -1, name: searchText, color: randomColor)) {}
        }
    }
}
