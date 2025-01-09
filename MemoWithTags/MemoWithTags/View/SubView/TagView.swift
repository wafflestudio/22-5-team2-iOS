//
//  TagCollectionViewCell.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import SwiftUI

struct TagView: View {
    var tag: Tag
    
    var body: some View {
        Text(tag.name)
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(Color.tagTextColor)
            .padding(.horizontal, 7)
            .frame(height: 25)
            .background(Color(hex: tag.color))
            .cornerRadius(4)
            .lineLimit(1)
            .truncationMode(.tail)
            //디버깅
            .onAppear {
                print("TagView: \nTags: \(tag)")
            }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(tag: Tag(id: 1, name: "Example Tag", color: "#FF5733"))
            .previewLayout(.sizeThatFits)
    }
}
