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
    
    @Namespace private var animationNamespace
    
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        VStack {
            ZStack {
                if !viewModel.editingMemoViewIsExpanded {
                    smallView
                        .matchedGeometryEffect(id: "editingMemoView", in: animationNamespace)
                } else {
                    expandedView
                        .matchedGeometryEffect(id: "editingMemoView", in: animationNamespace)
                }
            }
            .animation(.spring(), value: viewModel.editingMemoViewIsExpanded)
        }
        .navigationBarHidden(viewModel.editingMemoViewIsExpanded)
    }
    
    
    private var smallView: some View {
        VStack(alignment: .leading, spacing: 8) {
            DynamicHeightTextEditor(
                text: $viewModel.editingMemoContent,
                maxHeight: 100
            )
            .matchedGeometryEffect(id: "textEditor", in: animationNamespace)
            .focused($isTextEditorFocused)
            
            HStack(alignment: .bottom, spacing: 8) {
                HFlow {
                    ForEach(viewModel.editingMemoSelectedTags, id: \.id) { tag in
                        TagView(viewModel: viewModel, tag: tag) {
                            removeTagFromSelectedTags(tag)
                        }
                        .matchedGeometryEffect(id: "tag_\(tag.id)", in: animationNamespace)
                    }
                }
                
                Spacer()
                
                // Expand Button
                Button(action: {
                    withAnimation {
                        viewModel.editingMemoViewIsExpanded.toggle()
                        // shrink 하고 나서도 키보드가 안 내려가게
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.isTextEditorFocused = true
                        }
                    }
                }) {
                    Image(systemName: "arrow.down.left.and.arrow.up.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 19, height: 21)
                        .foregroundColor(.black)
                }
                
                // Create or Update Button
                Button(action: (viewModel.isUpdating ? updateMemoAction: createMemoAction)) {
                    Image(systemName: "highlighter")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 19, height: 21)
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 9)
        .padding(.bottom, 13)
        .background(Color.memoBackgroundWhite)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 2)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 7)
        .padding(.bottom, 14)
    }
    
    
    private var expandedView: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                DynamicHeightTextEditor(
                    text: $viewModel.editingMemoContent,
                    maxHeight: 400
                )
                .matchedGeometryEffect(id: "textEditor", in: animationNamespace)
                .focused($isTextEditorFocused)
                
                Spacer()
                
                HStack(alignment: .bottom, spacing: 8) {
                    HFlow {
                        ForEach(viewModel.editingMemoSelectedTags, id: \.id) { tag in
                            TagView(viewModel: viewModel, tag: tag) {
                                removeTagFromSelectedTags(tag)
                            }
                            .matchedGeometryEffect(id: "tag_\(tag.id)", in: animationNamespace)
                        }
                    }
                    
                    Spacer()
                    
                    // Collapse Button
                    Button(action: {
                        withAnimation {
                            viewModel.editingMemoViewIsExpanded.toggle()
                            // expand 하고 나서도 키보드가 안 내려가게
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.isTextEditorFocused = true
                            }
                        }
                    }) {
                        Image(systemName: "arrow.up.right.and.arrow.down.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 19, height: 21)
                            .foregroundColor(.black)
                    }
                    
                    // Create or Update Button
                    Button(action: (viewModel.isUpdating ? updateMemoAction: createMemoAction)) {
                        Image(systemName: "highlighter")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 19, height: 21)
                            .foregroundColor(.black)
                    }
        
                }
            
            }
            .padding(.horizontal, 14)
            .padding(.top, 9)
            .padding(.bottom, 13)
            .background(Color.memoBackgroundWhite)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider()
            
            HStack(spacing: 10) {
                Image(systemName: "textformat.size")
                    .font(.system(size: 20))
                    .foregroundColor(.tabBarNotSelectecdIconGray)
                
                Image(systemName: "bold")
                    .font(.system(size: 20))
                    .foregroundColor(.tabBarNotSelectecdIconGray)
                
                Image(systemName: "italic")
                    .font(.system(size: 20))
                    .foregroundColor(.tabBarNotSelectecdIconGray)
                
                Image(systemName: "underline")
                    .font(.system(size: 18))
                    .foregroundColor(.tabBarNotSelectecdIconGray)
                
                Image(systemName: "strikethrough")
                    .font(.system(size: 20))
                    .foregroundColor(.tabBarNotSelectecdIconGray)

                Image(systemName: "list.bullet")
                    .font(.system(size: 20))
                    .foregroundColor(.tabBarNotSelectecdIconGray)
                
                Image(systemName: "list.number")
                    .font(.system(size: 20))
                    .foregroundColor(.tabBarNotSelectecdIconGray)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 15)
            .background(Color.memoBackgroundWhite)
            
        }
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
