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
    
    @Namespace private var animationNamespace
    
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        VStack {
            ZStack {
                // Conditionally display small or expanded view
                if !isExpanded {
                    smallView
                        .matchedGeometryEffect(id: "memoContainer", in: animationNamespace)
                } else {
                    expandedView
                        .matchedGeometryEffect(id: "memoContainer", in: animationNamespace)
                }
            }
            .animation(.spring(), value: isExpanded)
        }
        .navigationBarHidden(isExpanded)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isTextEditorFocused = true
            }
        }
    }
    
    
    private var smallView: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                
                // Text Editor
                DynamicHeightTextEditor(
                    text: $content,
                    maxHeight: 100
                )
                .matchedGeometryEffect(id: "textEditor", in: animationNamespace)
                .focused($isTextEditorFocused)
                
                HStack(alignment: .center, spacing: 8) {
                    // Display selected tags
                    HFlow {
                        ForEach(viewModel.selectedTags, id: \.id) { tag in
                            TagView(tag: tag) {
                                removeTagFromSelectedTags(tag)
                            }
                            .matchedGeometryEffect(id: "tag_\(tag.id)", in: animationNamespace)
                        }
                    }
                    
                    Spacer()
                    
                    // Expand Button
                    Button(action: {
                        withAnimation {
                            self.isExpanded.toggle()
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
                    
                    // Create Memo Button
                    Button(action: createMemoAction) {
                        Image(systemName: "highlighter")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 19, height: 21)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal, 17)
            .padding(.top, 5)
            .padding(.bottom, 9)
            .background(Color.memoBackgroundWhite)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 2)
            .fixedSize(horizontal: false, vertical: true) // Constrain height dynamically
            .padding(.horizontal, 7)
            .padding(.bottom, 14)
        }
    }
    
    
    private var expandedView: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Text Editor
            DynamicHeightTextEditor(
                text: $content,
                maxHeight: 400
            )
            .matchedGeometryEffect(id: "textEditor", in: animationNamespace)
            .focused($isTextEditorFocused)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 8) {
                // Display selected tags
                HFlow {
                    ForEach(viewModel.selectedTags, id: \.id) { tag in
                        TagView(tag: tag) {
                            removeTagFromSelectedTags(tag)
                        }
                        .matchedGeometryEffect(id: "tag_\(tag.id)", in: animationNamespace)
                    }
                }
                
                Spacer()
                
                // Collapse Button
                Button(action: {
                    withAnimation {
                        self.isExpanded.toggle()
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
                
                // Create Memo Button
                Button(action: createMemoAction) {
                    Image(systemName: "highlighter")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 19, height: 21)
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.horizontal, 17)
        .padding(.top, 5)
        .padding(.bottom, 9)
        .background(Color.memoBackgroundWhite)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    
    // Function to remove a tag from selectedTags
    private func removeTagFromSelectedTags(_ tag: Tag) {
        viewModel.selectedTags.removeAll { $0.id == tag.id }
    }
    
    // Dismisses the keyboard.
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // Function to handle memo creation
    private func createMemoAction() {
        Task {
            let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedContent.isEmpty else {
                return
            }
            let tagIds = viewModel.selectedTags.map { $0.id }
            
            // Call the onConfirm closure with content and tag IDs
            await viewModel.createMemo(content: trimmedContent, tagIds: tagIds)
            
            // Reset the input fields
            content = ""
            viewModel.selectedTags = []
            hideKeyboard()
        }
    }
}
