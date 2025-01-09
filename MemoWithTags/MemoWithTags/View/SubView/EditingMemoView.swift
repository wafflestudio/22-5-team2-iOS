//
//  EditingMemoView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/6/25.
//

// EditingMemoView.swift

import SwiftUI

struct EditingMemoView: View {
    @State private var newContent: String = ""
    @State private var newTags: [Tag] = []
    @State private var collectionViewHeight: CGFloat = .zero
    @State private var textViewHeight: CGFloat = 40 // Initial height for the TextEditor
    @State private var dynamicHeight: CGFloat = 40
    var onConfirm: (String, [Int]) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Editable Text Area and Confirm Button in HStack
            HStack(alignment: .top, spacing: 8) {
                // Editable Text Area
                ZStack(alignment: .topLeading) {
                    if newContent.isEmpty {
                        Text("새로운 메모")
                            .foregroundColor(Color.gray.opacity(0.6))
                            .padding(8)
                    }
                    TextEditor(text: $newContent)
                        .frame(minHeight: textViewHeight, maxHeight: dynamicHeight)
                        .background(GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    dynamicHeight = geometry.size.height
                                }
                                .onChange(of: newContent) { newValue, oldValue in
                                    let newHeight = newValue.heightWithConstrainedWidth(width: geometry.size.width, font: UIFont.systemFont(ofSize: 17))
                                    DispatchQueue.main.async {
                                        dynamicHeight = max(40, newHeight + 20) // Adding padding
                                    }
                                }
                        })
                        .font(.body)
                }
                
                // Confirm Button
                Button(action: {
                    // Trim whitespace and newlines
                    let trimmedContent = newContent.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // Validation: Ensure there's content or at least one tag
                    guard !trimmedContent.isEmpty else {
                        return
                    }
                    
                    // Extract tag IDs
                    let tagIDs = newTags.map { $0.id }
                    
                    // Call the onConfirm closure with content and tag IDs
                    onConfirm(trimmedContent, tagIDs)
                    
                    // Reset the input fields
                    newContent = ""
                    newTags = []
                    
                    // Reset the heights
                    collectionViewHeight = .zero
                    dynamicHeight = 40
                    
                    // Dismiss the keyboard
                    hideKeyboard()
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
            
            // Tags
            TagCollectionView(
                tags: newTags,
                horizontalSpacing: 9,
                verticalSpacing: 7,
                collectionViewHeight: $collectionViewHeight
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: collectionViewHeight)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(Color.memoBackgroundWhite)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4) // Darker shadow
    }
    
    // Dismisses the keyboard.
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


extension String {
    /// Calculates the height required for the given string with constrained width and font.
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let adjustedWidth = max(width - 16, 1) // Ensure width is at least 1 to prevent invalid constraints
        let constraintRect = CGSize(width: adjustedWidth, height: .greatestFiniteMagnitude) // Adjust for padding
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
}


