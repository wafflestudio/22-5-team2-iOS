//
//  SignupView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/5/25.
//

import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordRepeat: String = ""
    
    @StateObject private var viewModel = SignupViewModel()
    
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
                
                //signup panel
                VStack(spacing: 0) {
                    VStack(spacing: 10) {
                        //이메일 입력 필드
                        TextField (
                            "",
                            text: $email,
                            prompt:
                                Text("이메일")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(Color(hex: "#94979F"))
                        )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .font(.system(size: 16, weight: .regular))
                        .background(.white)
                        .overlay (
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "#181E2226"), lineWidth: 1)
                        )
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        
                        // 비밀번호 입력 필드
                        VStack(spacing: 2) {
                            SecureField(
                                "",
                                text: $password,
                                prompt: Text("비밀번호")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(Color(hex: "#94979F"))
                            )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .font(.system(size: 16, weight: .regular))
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(hex: "#181E2226"), lineWidth: 1)
                            )
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .onChange(of: password) {
                                viewModel.checkPasswordValidity(password: password)
                            }
                            
                            //조건 표시
                            HStack {
                                Spacer()
                                Text("\(viewModel.satisfiedCount)/5")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundStyle(
                                        viewModel.isValidPassword ? Color.green : Color.dateGray
                                    )
                                    .padding(.horizontal, 6)
                            }
                        }
                        
                        //비밀번호 확인 필드
                        SecureField(
                            "",
                            text: $passwordRepeat,
                            prompt: Text("비밀번호 확인")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(Color(hex: "#94979F"))
                        )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .font(.system(size: 16, weight: .regular))
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "#181E2226"), lineWidth: 1)
                        )
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    }
                    
                    //회원가입 버튼
                    Button {
                        //action
                    } label: {
                        Text("다음")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)

                    }
                    .background(Color.titleTextBlack)
                    .cornerRadius(22)
                    .padding(.top, 16)
                    
                    HStack(spacing: 8) {
                        Tag(text: "로그인", size: 14, color: .init(hex: "#E3E3E7")) {
                            //action
                        }
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "#FFBDBD"))
                            .frame(width: 12, height: 24)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "#F1F1F3"))
                            .frame(width: 12, height: 24)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "#F1F1F3"))
                            .frame(width: 12, height: 24)
                        
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
    SignupView()
}
