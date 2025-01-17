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
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(Color.tagTextColor)
            .padding(.horizontal, 7)
            .padding(.vertical, 1)
            .background(tag.color.color)
            .cornerRadius(4)
            .lineLimit(1)
            .truncationMode(.tail)
            .onTapGesture {
                onTap?()
            }
    }
}
