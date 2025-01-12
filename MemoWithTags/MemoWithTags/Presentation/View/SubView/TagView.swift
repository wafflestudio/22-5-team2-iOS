//
//  TagCollectionViewCell.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import SwiftUI

struct TagView: View {
    var tag: Tag
    var onTap: (() -> Void)?
    
    var body: some View {
        Text(tag.name)
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(Color.tagTextColor)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color(hex: tag.color))
            .cornerRadius(4)
            .lineLimit(1)
            .truncationMode(.tail)
            .onTapGesture {
                onTap?()
            }
    }
}
