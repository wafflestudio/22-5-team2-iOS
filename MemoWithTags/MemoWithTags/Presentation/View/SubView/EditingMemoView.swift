//
//  EditingMemoView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/6/25.
//

import SwiftUI
import Flow

@available(iOS 18.0, *)
struct EditingMemoView: View {
    @ObservedObject var viewModel: MainViewModel
    
    @FocusState private var isTextEditorFocused: Bool
    
    @Namespace var namespace
    
    var body: some View {
        HStack(alignment: .bottom) {
            
            VStack(alignment: .leading) {
                // 메모글 쓰는 곳
                DynamicHeightTextEditor(
                    text: $viewModel.editingMemoContent,
                    maxHeight: 100
                )
                .focused($isTextEditorFocused)
                
                // 메모에 넣은 태그들
                HFlow {
                    ForEach(viewModel.editingMemoSelectedTags, id: \.id) { tag in
                        TagView(viewModel: viewModel, tag: tag) {
                            removeTagFromSelectedTags(tag)
                        }
                    }
                }
            }

            HStack {
                Button {
                    viewModel.appState.navigation.push(to: .memoEditor(namespace: namespace, id: "zoom"))
                } label: {
                    Image(systemName: "arrow.down.left.and.arrow.up.right")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                }
                .padding(.bottom, 10)
                
                // Create or Update Button
                Button(action: (viewModel.isUpdating ? updateMemoAction : createMemoAction)) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
                .padding(.bottom, 10)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 17)
        .background(Color.memoBackgroundWhite)
        .cornerRadius(14)
        .matchedTransitionSource(id: "zoom", in: namespace)
        .padding(.horizontal, 7)
        .padding(.bottom, 14)
        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 2)
    }
    
    
    private func removeTagFromSelectedTags(_ tag: Tag) {
        viewModel.editingMemoSelectedTags.removeAll { $0.id == tag.id }
    }

    private func createMemoAction() {
        Task {
            let trimmedContent = viewModel.editingMemoContent.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedContent.isEmpty else { return }
            
            let tagIds = viewModel.editingMemoSelectedTags.map { $0.id }
            
            await viewModel.createMemo(content: trimmedContent, tagIds: tagIds, locked: false)
            
            viewModel.memos = []
            viewModel.mainCurrentPage = 0
            await viewModel.fetchMemos()
            
            // Reset the input fields
            viewModel.editingMemoContent = ""
            viewModel.editingMemoSelectedTags = []
            viewModel.hideKeyboard()
        }
    }
    
    private func updateMemoAction() {
        Task {
            let trimmedContent = viewModel.editingMemoContent.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedContent.isEmpty else { return}
            
            let tagIds = viewModel.editingMemoSelectedTags.map { $0.id }
            
            await viewModel.updateMemo(memoId: viewModel.updatingMemoId!, content: trimmedContent, tagIds: tagIds, locked: viewModel.updatingMemoIsLocked!)
            
            // Reset the input fields
            viewModel.isUpdating = false
            viewModel.updatingMemoId = nil
            viewModel.editingMemoContent = ""
            viewModel.editingMemoSelectedTags = []
            viewModel.updatingMemoIsLocked = nil
            viewModel.hideKeyboard()
        }
    }
}
