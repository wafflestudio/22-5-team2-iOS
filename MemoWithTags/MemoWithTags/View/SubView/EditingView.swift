//
//  EditingView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/9/25.
//

import SwiftUI

struct EditingView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var keyboardResponder: KeyboardResponder
    
    @State private var selectedTags: [Tag] = []
    @State private var newContent: String = ""
    @State private var dynamicTextEditorHeight: CGFloat = 32
    @State private var dynamicTagCollectionViewHeight: CGFloat = .zero
    
    var body: some View {
        VStack {
            // Always visible EditingMemoView
            EditingMemoView(
                content: $newContent,
                selectedTags: $selectedTags,
                dynamicTextEditorHeight: $dynamicTextEditorHeight,
                dynamicTagCollectionViewHeight: $dynamicTagCollectionViewHeight,
                onConfirm: { content, tagIDs in
                    mainViewModel.createMemo(content: content, tags: tagIDs)
                    // Reset the input fields
                    newContent = ""
                    selectedTags = []
                    // Reset heights
                    dynamicTagCollectionViewHeight = .zero
                    dynamicTextEditorHeight = 40
                }
            )
            .padding(.horizontal, 7)
            .padding(.bottom, 14)
            
            // EditingTagListView visible only when keyboard is up
            if keyboardResponder.currentHeight > 0 {
                EditingTagListView(
                    availableTags: availableTags(),
                    onTagSelected: { tag in
                        addTag(tag)
                    }
                )
                .padding(.horizontal, 14)
                .padding(.bottom, keyboardResponder.currentHeight)
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: keyboardResponder.currentHeight)
            }
        }
    }
    
    // Compute available tags by excluding selectedTags
    private func availableTags() -> [Tag] {
        mainViewModel.tags.filter { !selectedTags.contains($0) }
    }
    
    // Add a tag to selectedTags
    private func addTag(_ tag: Tag) {
        selectedTags.append(tag)
    }
    
    // Remove a tag from selectedTags
    private func removeTag(_ tag: Tag) {
        selectedTags.removeAll { $0.id == tag.id }
    }
}
