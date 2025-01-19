//
//  LoginView.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        ZStack {
            Color.backgroundGray.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 36) {
                //title
                HStack(spacing: 4) {
                    Text("Memo with")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.titleTextBlack)
                    
                    DesignTagView(text: "Tags", fontSize: 19, fontWeight: .regular, horizontalPadding: 8, verticalPadding: 3, backGroundColor: "#E3E3E7", cornerRadius: 4) {}
                }
                .padding(.vertical, 8)
                .background(.clear)
                
                //login panel
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
                    }
                    
                    //로그인 버튼
                    Button {
                        //action
                        Task {
                            await viewModel.login(email: email, password: password)
                        }

                    } label: {
                        Text("로그인")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)

                    }
                    .background(email.isEmpty || password.isEmpty ? Color(hex: "#E3E3E7") : Color.titleTextBlack)
                    .cornerRadius(22)
                    .padding(.top, 16)
                    .disabled(email.isEmpty || password.isEmpty)
                    
                    Divider().padding(.vertical, 16)
                    
                    HStack(spacing: 8) {
                        // 카카오 로그인 버튼
                        Image(.kakaoLogin)
                            .resizable()
                            .frame(width: 60, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        
                        // 네이버 로그인 버튼
                        Image(.naverLogin)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        
                        // 구글 로그인 버튼
                        HStack(spacing: 4) {
                            Image(.googleIcon)
                                .resizable()
                                .frame(width: 16, height: 16)
                            
                            Text("로그인")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 60, height: 30)
                        .background(Color(hex: "#f5f5f5"))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        
                    }
                    
                    HStack(spacing: 8) {
                        DesignTagView(text: "회원가입", fontSize: 14, fontWeight: .regular, horizontalPadding: 8, verticalPadding: 3, backGroundColor: "#FFBDBD", cornerRadius: 4) {
                            viewModel.appState.navigation.push(to: .signup)
                        }
                        
                        Spacer()
                        
                        DesignTagView(text: "비밀번호 찾기", fontSize: 14, fontWeight: .regular, horizontalPadding: 8, verticalPadding: 3, backGroundColor: "#F1F1F3", cornerRadius: 4) {
                            viewModel.appState.navigation.push(to: .forgotPassword)
                        }
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
        .navigationBarBackButtonHidden()
    }
}
