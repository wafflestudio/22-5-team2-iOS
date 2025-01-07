//
//  EditingMemoView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/6/25.
//

// EditingMemoView.swift

import SwiftUI

struct EditingMemoView: View {
    @State var memo: Memo
    @State private var collectionViewHeight: CGFloat = .zero
    @State private var textViewHeight: CGFloat = 40 // Initial height for the TextEditor
    @State private var dynamicHeight: CGFloat = .zero
    var onConfirm: (String, [Int]) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Editable Text Area and Confirm Button in HStack
            HStack(alignment: .top, spacing: 8) {
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
                                .onChange(of: memo.content) { newValue in
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
                    // onConfirm 호출 시 content와 tag IDs 전달
                    let tagIDs = memo.tags.map { $0.id }
                    onConfirm(memo.content, tagIDs)
                    // 메모 내용 초기화
                    memo.content = ""
                    memo.tags = []
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
                tags: memo.tags,
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

