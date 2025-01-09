//
//  DynamicHeightTextEditor.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/9/25.
//

import SwiftUI

struct DynamicHeightTextEditor: View {
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    var placeholder: String
    var minHeight: CGFloat = 40
    var maxHeight: CGFloat = 200 // Optional: Set a maximum height if desired

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.gray.opacity(0.6))
                    .padding(8)
            }
            TextEditor(text: $text)
                .frame(minHeight: minHeight, maxHeight: dynamicHeight)
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            updateHeight(from: geometry.size)
                        }
                        .onChange(of: text) { _, _ in
                            // Calculate new height based on content
                            let newHeight = text.heightWithConstrainedWidth(
                                width: geometry.size.width,
                                font: UIFont.systemFont(ofSize: 17)
                            )
                            DispatchQueue.main.async {
                                dynamicHeight = min(max(newHeight + 20, minHeight), maxHeight)
                            }
                        }
                })
                .font(.body)
                .disableAutocorrection(true)
        }
    }

    private func updateHeight(from size: CGSize) {
        let calculatedHeight = text.heightWithConstrainedWidth(
            width: size.width,
            font: UIFont.systemFont(ofSize: 17)
        )
        dynamicHeight = min(max(calculatedHeight + 20, minHeight), maxHeight)
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
