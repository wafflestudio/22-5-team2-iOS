//
//  EditingTagListView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/6/25.
//

import SwiftUI

struct EditingTagListView: View {
    var availableTags: [Tag] // Tags not selected in EditingMemoView
    var onTagSelected: (Tag) -> Void // Callback when a tag is selected
    @State private var searchText: String = ""
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // Search Field
            TextField("Search Tags", text: $searchText)
                .font(.custom("Pretendard", size: 16))
                .foregroundColor(Color.searchBarPlaceholderGray)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
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
                        TagView(tag: tag) {
                            onTagSelected(tag)
                        }
                    }
                }
            }
            .frame(height: 36) // Prevent ScrollView from expanding vertically
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
            return availableTags
        } else {
            return availableTags.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

