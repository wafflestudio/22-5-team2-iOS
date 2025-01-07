//
//  SignupSuccessView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/6/25.
//

import SwiftUI

struct SignupSuccessView: View {
    var body: some View {
        ZStack {
            Color.backgroundGray.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 36) {
                //title
                HStack(spacing: 4) {
                    Text("이메일로 회원가입")
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(Color.titleTextBlack)
                }
                .padding(.vertical, 8)
                .background(.clear)
                
                //auth panel
                VStack(spacing: 0) {
                    //환영글
                    VStack(spacing: 2) {
                        HStack(spacing: 2) {
                            HStack(spacing: 3) {
                                Text("Memo with")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(Color.titleTextBlack)
                                Tag(text: "Tags", size: 14, color: .init(white: 0, opacity: 0.1)) {}
                            }
                            Text("를 통해")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundStyle(Color.titleTextBlack)
                        }
                        Text("복잡한 메모들을 간단하고 효율적으로 정리해보세요!")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(Color.titleTextBlack)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                    
                    //시작버튼
                    Button {
                        //action
                    } label: {
                        Text("시작하기")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                    }
                    .background(Color(hex: "#FF9C9C"))
                    .cornerRadius(22)
                    .padding(.top, 16)
                    
                    HStack(spacing: 8) {
                        Tag(text: "다른 계정으로 로그인", size: 14, color: .init(hex: "#F1F1F3")) {
                            //action
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 36)
                    
                }
                .padding(.top, 18)
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 12)
            .background(.clear)
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)

        }
    }
    
    @ViewBuilder private func Tag(text: String, size: CGFloat, color: Color, onClink: @escaping () -> Void) -> some View {
        Text(text)
            .font(.system(size: size, weight: .regular))
            .foregroundStyle(Color.tagTextColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color)
            .cornerRadius(4)
            .onTapGesture {
                onClink()
            }
    }
}

#Preview {
    SignupSuccessView()
}
