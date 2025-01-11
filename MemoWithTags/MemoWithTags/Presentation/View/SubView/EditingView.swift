//
//  EditingView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/9/25.
//

import SwiftUI

struct EditingView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @EnvironmentObject var keyboardResponder: KeyboardResponder
    
    @State private var selectedTags: [Tag] = []
    @State private var newContent: String = ""
    @State private var dynamicTextEditorHeight: CGFloat = 40
    
    var body: some View {
        VStack {
            Spacer()
            
            // Always visible EditingMemoView
            EditingMemoView(
                content: $newContent,
                selectedTags: $selectedTags,
                dynamicTextEditorHeight: $dynamicTextEditorHeight,
                onConfirm: { content, tagIds in
                    mainViewModel.createMemo(content: content, tagIds: tagIds)
                    // Reset the input fields
                    newContent = ""
                    selectedTags = []
                    // Reset heights
                    dynamicTextEditorHeight = 40
                }
            )
            .padding(.horizontal, 7)
            .padding(.bottom, 14)
            //.frame(maxHeight: .infinity) // Constrain max height
            
            // EditingTagListView visible only when keyboard is up
            if keyboardResponder.currentHeight > 0 {
                EditingTagListView(
                    //mainViewModel: mainViewModel, // 이 부분 확인해줘
                    availableTags: availableTags(),
                    onTagSelected: { tag in
                        addTagToSelectedTags(tag)
                    },
                    mainViewModel: mainViewModel
                )
            }
        }
    }
    
    // Compute available tags by excluding selectedTags
    private func availableTags() -> [Tag] {
        mainViewModel.tags.filter { !selectedTags.contains($0) }
    }
    
    // Add a tag to selectedTags
    private func addTagToSelectedTags(_ tag: Tag) {
        selectedTags.append(tag)
    }
}
