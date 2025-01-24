//
//  test.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/24/25.
//
import SwiftUI
import RichTextKit
import Flow

struct MemoEditorView: View {
    @ObservedObject var viewModel: MainViewModel
    
    @State private var text = NSAttributedString(string: "")
    @StateObject var context = RichTextContext()
    
    @FocusState private var isTextEditorFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                RichTextEditor(text: $text, context: context)
                    .focused($isTextEditorFocused)
                    .overlay(Group { // placeholder
                        if !isTextEditorFocused && text.string.isEmpty {
                            Text("메모를 작성해보세요.")
                                .foregroundStyle(Color.dividerGray)
                                .offset(x: 0, y: 5)
                        }
                    }, alignment: .topLeading)

                HStack(alignment: .bottom, spacing: 8) {
                    HFlow {
                        ForEach(viewModel.editingMemoSelectedTags, id: \.id) { tag in
                            TagView(viewModel: viewModel, tag: tag) {
                                
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "highlighter")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 19, height: 21)
                            .foregroundColor(.black)
                    }
        
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.memoBackgroundWhite)
            

            
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18))
                    .onTapGesture {
                        viewModel.appState.navigation.pop()
                    }
                Divider()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

