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
    
    @Binding var selectedTags: [Tag]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                // Text 치는 곳
                DynamicHeightTextEditor(text: $content)
                
                // 전체 화면 수정 버튼
                Button(action: {
                    // 지금 이 EditingMemoView가 전체 화면으로 커지면서 TextEditor가 전체 화면이 되어 수정이 가능해짐
                }) {
                    Image(systemName: "arrow.down.left.and.arrow.up.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 19, height: 21)
                        .foregroundColor(.black)
                }
                
                // 메모 생성 버튼
                Button(action: {
                    Task {
                        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmedContent.isEmpty else {
                            return
                        }
                        let tagIds = selectedTags.map { $0.id }
                        
                        // Call the onConfirm closure with content and tag IDs
                        await viewModel.createMemo(content: trimmedContent, tagIds: tagIds)
                        
                        // Reset the input fields
                        content = ""
                        selectedTags = []
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
            if !selectedTags.isEmpty {
                HFlow{
                    ForEach(selectedTags, id: \.id) { tag in
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
