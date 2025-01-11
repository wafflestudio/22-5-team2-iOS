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
    
    @ObservedObject var mainViewModel: MainViewModel
    @State private var searchText: String = ""
    @State private var randomColor: String = ""
    
    // 상태 변수를 sheet(item:)에 맞게 수정
    @State private var tagToUpdate: Tag? = nil
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // Search Field
            TextField("태그 검색", text: $searchText)
                .font(.custom("Pretendard", size: 16))
                .foregroundColor(Color.searchBarPlaceholderGray)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .frame(width: 100)
                .background(Color.searchBarBackgroundGray)
                .cornerRadius(20)
            
            // Divider Line
            Rectangle()
                .foregroundColor(Color.dividerGray)
                .frame(width: 0.3, height: 32)
            
            // Scrollable Tag List
            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: 8) {
                    ForEach(filteredTags(), id: \.id) { tag in
                        TagView(tag: tag) {
                            onTagSelected(tag)
                        }
                        .contextMenu {
                            Button {
                                hideKeyboard()
                                tagToUpdate = tag
                            } label: {
                                Label("Update", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                mainViewModel.deleteTag(tagId: tag.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    
                    // "Create Tag" TagView
                    if canCreateTag() {
                        CreateTagView(
                            searchText: $searchText,
                            randomColor: $randomColor
                        )
                        .onTapGesture {
                            mainViewModel.createTag(name: searchText, color: randomColor)
                            generateRandomHexColor()
                        }
                    }
                }
                .padding(.horizontal, 8)
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
        .onAppear {
            generateRandomHexColor()
        }
        // sheet(item:)을 사용하여 tagToUpdate가 설정되면 시트를 표시
        .sheet(item: $tagToUpdate) { tag in
            UpdateTagView(mainViewModel: mainViewModel, tag: tag)
        }
    }
    
    // Function to filter tags based on search text
    private func filteredTags() -> [Tag] {
        if searchText.isEmpty {
            return availableTags
        } else {
            return availableTags.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Determine if a new tag can be created
    private func canCreateTag() -> Bool {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedText.isEmpty && !availableTags.contains { $0.name.lowercased() == trimmedText.lowercased() }
    }
    
    // Generate a random HEX color string from TagColor enum
    private func generateRandomHexColor() {
        if let randomTagColor = Color.TagColor.allCases.randomElement() {
            randomColor = randomTagColor.rawValue
        }
    }
    
    // Dismisses the keyboard.
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
