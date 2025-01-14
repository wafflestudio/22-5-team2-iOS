//
//  DesignTagView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/14/25.
//

import SwiftUI

struct DesignTagView: View {
    let text: String
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let backGroundColor: String
    let cornerRadius: CGFloat
    
    let onTap: (() -> Void)?
    
    var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: fontWeight))
            .foregroundStyle(Color.tagTextColor)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(Color.init(hex: backGroundColor))
            .cornerRadius(cornerRadius)
            .onTapGesture {
                onTap?()
            }
    }
}
