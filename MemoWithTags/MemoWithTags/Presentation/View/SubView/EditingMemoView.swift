//
//  EditingMemoView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/6/25.
//

import SwiftUI
import Flow

struct EditingMemoView: View {
    @Binding var content: String
    @Binding var selectedTags: [Tag]
    @Binding var dynamicTextEditorHeight: CGFloat
    
    var onConfirm: (String, [Int]) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Editable Text Area and Confirm Button in HStack
            HStack(alignment: .top, spacing: 8) {
                // Editable Text Area
                DynamicHeightTextEditor(
                    text: $content,
                    dynamicHeight: $dynamicTextEditorHeight,
                    placeholder: "새로운 메모"
                )
                .frame(height: dynamicTextEditorHeight)
                .background(Color.clear)
                
                // Confirm Button
                Button(action: {
                    // Trim whitespace and newlines
                    let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // Validation: Ensure there's content
                    guard !trimmedContent.isEmpty else {
                        return
                    }
                    
                    // Extract tag IDs
                    let tagIDs = selectedTags.map { $0.id }
                    
                    // Call the onConfirm closure with content and tag IDs
                    onConfirm(trimmedContent, tagIDs)
                    
                    // Reset the input fields
                    content = ""
                    selectedTags = []
                    
                    dynamicTextEditorHeight = 40
                    
                    // Dismiss the keyboard
                    hideKeyboard()
                }) {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.blue)
                        .cornerRadius(16)
                }
            }
            
            HFlow{
                ForEach(selectedTags, id: \.id) { tag in
                    TagView(tag: tag) {
                        removeTagFromSelectedTags(tag)
                    }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(Color.memoBackgroundWhite)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4)
        .fixedSize(horizontal: false, vertical: true) // Constrain height dynamically
    }
    
    // Function to remove a tag from selectedTags
    private func removeTagFromSelectedTags(_ tag: Tag) {
        selectedTags.removeAll { $0.id == tag.id }
    }
    
    // Dismisses the keyboard.
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}