//
//  EditingTagListView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/6/25.
//

import SwiftUI

import SwiftUI

struct EditingTagListView: View {
    
    var tags: [Tag]
    @State private var searchText: String = ""
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // Search Field
            TextField("Search Tags", text: $searchText)
                .font(.custom("Pretendard", size: 16))
                .foregroundColor(Color.searchBarPlaceholderGray)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .frame(width: 130) // 이렇게 해야 TextField의 가로 길이가 안 길어진다.
                .background(Color.searchBarBackgroundGray)
                .cornerRadius(20)
            
            // Divider Line
            Rectangle()
                .foregroundColor(Color.dividerGray)
                .frame(width: 0.3, height: 32)
            
            // Scrollable Tag List
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 8) {
                    ForEach(filteredTags(), id: \.id) { tag in
                        TagView(tag: tag)
                    }
                }
            }
            .frame(height: 36) // 이렇게 해야 ScrollView의 세로 길이가 안 길어진다.
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 2)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.backgroundGray)
        .overlay(
          Rectangle()
            .inset(by: 0.2)
            .stroke(Color(red: 0.6, green: 0.6, blue: 0.6), lineWidth: 0.4)
        )
    }
    
    // Function to filter tags based on search text
    private func filteredTags() -> [Tag] {
        if searchText.isEmpty {
            return tags
        } else {
            return tags.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct EditingTagListView_Previews: PreviewProvider {
    static var previews: some View {
        EditingTagListView(
            tags: [
                Tag(id: 1, name: "Lorem ipsum", color: "#FF9C9C"),
                Tag(id: 2, name: "dolor", color: "#FFF56F"),
                Tag(id: 3, name: "sit", color: "#A6F7EA"),
                Tag(id: 4, name: "amet", color: "#D2E8FE"),
                Tag(id: 5, name: "consectetur adipiscing elit", color: "#92EDA1"),
                Tag(id: 6, name: "sed", color: "#CCFFF7"),
                Tag(id: 7, name: "do", color: "#FFD9EC"),
                Tag(id: 8, name: "eiusmod tempor incididunt ut labore et dolore magna aliqua", color: "#B0E0E6")
                // Add more tags if needed for testing
            ]
        )
    }
}
