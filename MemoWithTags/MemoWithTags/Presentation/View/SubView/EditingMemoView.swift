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

    @State var isExpanded: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    // Text 치는 곳
                    DynamicHeightTextEditor(text: $content)
                    
                    // 전체 화면 수정 버튼
                    Button(action: {
                        self.isExpanded.toggle()
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
                if !viewModel.selectedTags.isEmpty {
                    HFlow{
                        ForEach(viewModel.selectedTags, id: \.id) { tag in
                            TagView(tag: tag) {
                                removeTagFromSelectedTags(tag)
                            }
                        }
                        let tagIds = viewModel.selectedTags.map { $0.id }
                        
                        await viewModel.createMemo(content: trimmedContent, tagIds: tagIds)
                        
                        // Reset the input fields
                        content = ""
                        viewModel.selectedTags = []
                        dynamicTextEditorHeight = 40
                        hideKeyboard()
                    }
                }
                
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 5)
            .background(Color.memoBackgroundWhite)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4)
            .fixedSize(horizontal: false, vertical: true) // Constrain height dynamically
            .padding(.horizontal, 7)
            .padding(.bottom, 14)
        }
        
        // 확장된 뷰 (구조는 거의 똑같다.)
        if isExpanded {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    // Text 치는 곳
                    DynamicHeightTextEditor(text: $content)
                    
                    // 전체 화면 수정 버튼
                    Button(action: {
                        self.isExpanded.toggle()
                    }) {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
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

                          
                // 메모에 추가한 태그 나타나는 곳
                if !viewModel.selectedTags.isEmpty {
                    HFlow{
                        ForEach(viewModel.selectedTags, id: \.id) { tag in
                            TagView(tag: tag) {
                                removeTagFromSelectedTags(tag)
                            }
                        }
                        let tagIds = viewModel.selectedTags.map { $0.id }
                        
                        await viewModel.createMemo(content: trimmedContent, tagIds: tagIds)
                        
                        // Reset the input fields
                        content = ""
                        viewModel.selectedTags = []
                        dynamicTextEditorHeight = 40
                        hideKeyboard()
                    }
                }
                
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 5)
            .background(Color.memoBackgroundWhite)
            .transition(.move(edge: .bottom)) // 원하는 애니메이션으로 변경 가능
        }
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
