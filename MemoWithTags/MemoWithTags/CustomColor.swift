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
    
    // HSB 색 표현법을 기준으로 hue를 받으면 saturation과 brightness를 계산해서 온전한 Tag Color를 반환한다.
    static func tagBackgroundColor(hue: Int) -> Color {
        
        // 입력 hue 값의 유효성 검사
        guard (0 <= hue) && (hue < 360) else {return .red}
        
        // 채도(S)와 명도(B) 변수 초기화
        let saturation: Double
        let brightness: Double
        
        // H값에 따라 S와 B 설정
        switch hue {
        case 50..<200:
            saturation = 0.30
            brightness = 0.98
        case 200..<230:
            saturation = 0.28
            brightness = 0.99
        case 230..<360, 0..<20:
            saturation = 0.26
            brightness = 1.00
        case 20..<50:
            saturation = 0.28
            brightness = 0.99
        default:
            saturation = 0.28
            brightness = 0.99
        }
        
        return Color(hue: Double(hue) / 360.0, saturation: saturation, brightness: brightness)
    }
    
}
