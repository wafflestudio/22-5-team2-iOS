//
//  EditingMemoView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/6/25.
//

import SwiftUI
import Flow

struct EditingMemoView: View {
    @ObservedObject var viewModel: MainViewModel
    
    @State var content: String = ""
    @State var dynamicTextEditorHeight: CGFloat = 40
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                // Text 치는 곳
                DynamicHeightTextEditor(
                    text: $content,
                    dynamicHeight: $dynamicTextEditorHeight,
                    placeholder: "새로운 메모"
                )
                .frame(height: dynamicTextEditorHeight)
                .background(Color.clear)
                
                // 메모 생성 버튼
                Button(action: {
                    Task {
                        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmedContent.isEmpty else {
                            return
                        }
                        let tagIds = viewModel.selectedTags.map { $0.id }
                        
                        await viewModel.createMemo(content: trimmedContent, tagIds: tagIds)
                        
                        // Reset the input fields
                        content = ""
                        viewModel.selectedTags = []
                        dynamicTextEditorHeight = 40
                        hideKeyboard()
                    }
                }) {
                    Image(systemName: "highlighter")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 19, height: 21)
                        .foregroundColor(.black)
                }
            }
            
            // 메모에 추가한 태그 나타나는 곳
            if !viewModel.selectedTags.isEmpty {
                HFlow {
                    ForEach(viewModel.selectedTags, id: \.id) { tag in
                        TagView(tag: tag) {
                            removeTagFromSelectedTags(tag)
                        }
                    }
                }
            }

        }
        .padding(.horizontal, 17)
        .padding(.vertical, 5)
        .background(Color.memoBackgroundWhite)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 1.5)
        .fixedSize(horizontal: false, vertical: true) // Constrain height dynamically

    }
    
    // Function to remove a tag from selectedTags
    private func removeTagFromSelectedTags(_ tag: Tag) {
        viewModel.selectedTags.removeAll { $0.id == tag.id }
    }
    
    // Dismisses the keyboard.
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
