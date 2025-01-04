//
//  CustomColor.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 12/28/24.
//

import SwiftUICore

extension Color {
    static let backgroundGray: Color = .init(red: 241 / 255, green: 241 / 255, blue: 243 / 255)
    
    static let tabBarDividerGray: Color = .init(red: 176 / 255, green: 176 / 255, blue: 177 / 255)
    static let tabBarSelectecdIconBlack: Color = .init(red: 32 / 255, green: 32 / 255, blue: 33 / 255)
    static let tabBarNotSelectecdIconGray: Color = .init(red: 160 / 255, green: 160 / 255, blue: 161 / 255)
    
    static let titleTextBlack: Color = .init(red: 32 / 255, green: 32 / 255, blue: 33 / 255)
    
    static let memoBackgroundWhite: Color = .init(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let memoTextBlack: Color = .init(red: 32 / 255, green: 32 / 255, blue: 33 / 255)
    static let dateGray: Color = .init(red: 160 / 255, green: 160 / 255, blue: 161 / 255)
    
    static let searchBarBackgroundGray: Color = .init(red: 229 / 255, green: 229 / 255, blue: 230 / 255)
    static let searchBarPlaceholderGray: Color = .init(red: 176 / 255, green: 176 / 255, blue: 177 / 255)
    static let searchBarIconGray: Color = .init(red: 176 / 255, green: 176 / 255, blue: 177 / 255)
    
    static let tagTextColor: Color = .init(red: 26 / 255, green: 26 / 255, blue: 27 / 255).opacity(0.8)
    
    init(hex: String) {
        // HEX 문자열에서 # 제거
        let cleanedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        // 기본 값 (0, 0, 0) (블랙)
        var int: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&int)
        
        let red, green, blue, alpha: Double
        
        switch cleanedHex.count {
        case 3: // 3글자짜리 HEX 표현 (#RGB)
            red   = Double((int >> 8) & 0xF) / 15.0
            green = Double((int >> 4) & 0xF) / 15.0
            blue  = Double(int & 0xF) / 15.0
            alpha = 1.0
        case 6: // 6글자짜리 HEX 표현 (#RRGGBB)
            red   = Double((int >> 16) & 0xFF) / 255.0
            green = Double((int >> 8) & 0xFF) / 255.0
            blue  = Double(int & 0xFF) / 255.0
            alpha = 1.0
        case 8: // 8글자짜리 HEX 표현 (#AARRGGBB)
            alpha = Double((int >> 24) & 0xFF) / 255.0
            red   = Double((int >> 16) & 0xFF) / 255.0
            green = Double((int >> 8) & 0xFF) / 255.0
            blue  = Double(int & 0xFF) / 255.0
        default:
            red = 0
            green = 0
            blue = 0
            alpha = 1
        }
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
