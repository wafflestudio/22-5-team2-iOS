//
//  LoginView.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var router: NavigationRouter
    @StateObject private var viewModel = LoginViewModel()
    
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
                    Tag(text: "Tags", size: 19, color: .init(white: 0, opacity: 0.1)) {}
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
                            if !viewModel.isLoading && viewModel.isLoggedIn{
                                router.push(to: .main)
                            }
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
                    
                    HStack(spacing: 8) {
                        Tag(text: "이메일로 회원가입", size: 14, color: .init(hex: "#FFBDBD")) {
                            router.push(to: .signup)
                        }
                        
                        Spacer()
                        
                        Tag(text: "이메일 찾기", size: 14, color: .init(hex: "#F1F1F3")) {}
                        
                        Tag(text: "비밀번호 찾기", size: 14, color: .init(hex: "#F1F1F3")) {}
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
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("확인"))
            )
        }
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder private func Tag(text: String, size: CGFloat, color: Color, onClick: @escaping () -> Void) -> some View {
        Text(text)
            .font(.system(size: size, weight: .regular))
            .foregroundStyle(Color.tagTextColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color)
            .cornerRadius(4)
            .onTapGesture {
                onClick()
            }
    }
    
}
