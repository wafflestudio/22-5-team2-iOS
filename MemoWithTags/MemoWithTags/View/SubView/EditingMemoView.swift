//
//  EditingMemoView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/6/25.
//

import SwiftUI

struct EditingMemoView: View {
    @State var memo: Memo
    @State private var collectionViewHeight: CGFloat = .zero
    @State private var textViewHeight: CGFloat = 40 // Initial height for the TextEditor
    @State private var dynamicHeight: CGFloat = .zero
    var onConfirm: (Memo) -> Void // Called when the Send button is pressed
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Editable Text Area
            ZStack(alignment: .topLeading) {
                if memo.content.isEmpty {
                    Text("Enter your memo here...")
                        .foregroundColor(Color.gray.opacity(0.6))
                        .padding(8)
                }
                TextEditor(text: $memo.content)
                    .frame(minHeight: textViewHeight, maxHeight: dynamicHeight)
                    .background(GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                dynamicHeight = geometry.size.height
                            }
                            .onChange(of: memo.content) { newValue, oldValue in
                                let newHeight = newValue.heightWithConstrainedWidth(width: geometry.size.width, font: UIFont.systemFont(ofSize: 17))
                                DispatchQueue.main.async {
                                    dynamicHeight = max(40, newHeight + 20) // Adding padding
                                }
                            }
                    })
                    .font(.body)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Tags and Confirm Button
            GeometryReader { geometry in
                HStack(alignment: .top, spacing: 8) {
                    // Tags
                    TagCollectionView(
                        tags: memo.tags,
                        horizontalSpacing: 9,
                        verticalSpacing: 7,
                        collectionViewHeight: $collectionViewHeight
                    )
                    .frame(width: geometry.size.width - 60, alignment: .leading)
                    
                    // Confirm Button
                    Button(action: {
                        onConfirm(memo)
                    }) {
                        Image(systemName: "arrow.up") // Icon change
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20) // Adjust icon size
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40) // Adjust button size
                            .background(Color.blue)
                            .cornerRadius(20) // Circular button
                    }
                }
                .frame(width: geometry.size.width, alignment: .leading)
            }
            .frame(height: collectionViewHeight)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(Color.memoBackgroundWhite)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4) // Darker shadow
    }
}

extension String {
    /// Calculates the height required for the given string with constrained width and font.
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width - 16, height: .greatestFiniteMagnitude) // Adjust for padding
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
}

struct EditingMemoView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample Tag instances
        let sampleTags = [
            Tag(id: 1, name: "Lorem ipsum", color: "#FF9C9C"),
            Tag(id: 2, name: "dolor", color: "#FFF56F"),
            Tag(id: 3, name: "sit", color: "#A6F7EA"),
            Tag(id: 4, name: "amet", color: "#D2E8FE"),
            Tag(id: 5, name: "consectetur adipiscing elit", color: "#92EDA1"),
            Tag(id: 6, name: "sed", color: "#CCFFF7"),
            Tag(id: 7, name: "do", color: "#FFD9EC"),
            Tag(id: 8, name: "eiusmod tempor incididunt ut labore et dolore magna aliqua", color: "#B0E0E6")
        ]
        
        // Sample Memo instance
        let sampleMemo = Memo(
            id: 1,
            content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            tags: sampleTags,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // EditingMemoView Preview
        EditingMemoView(memo: sampleMemo, onConfirm: { memo in
            print("Send button clicked: \(memo)")
        })
        .padding()
        .background(Color.backgroundGray)
    }
}
