//
//  ForgotPasswordView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/15/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: ViewModel
    
    @State private var email: String = ""
    
    var body: some View {
        ZStack {
            Color.backgroundGray.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 36) {
                //login panel
                VStack(spacing: 0) {
                    VStack(spacing: 10) {
                        Text("인증코드를 받을 이메일을 입력해주세요.")
                            .padding(.vertical, 8)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(Color.titleTextBlack)
                        
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
                    }
                    
                    //확인 버튼
                    Button {
                        //action
                    } label: {
                        Text("인증코드 발송")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)

                    }
                    .background(email.isEmpty ? Color(hex: "#E3E3E7") : Color.titleTextBlack)
                    .cornerRadius(22)
                    .padding(.top, 16)
                    .disabled(email.isEmpty)
                    
                    HStack(spacing: 8) {
                        DesignTagView(text: "이전", fontSize: 14, fontWeight: .regular, horizontalPadding: 8, verticalPadding: 3, backGroundColor: "#E3E3E7", cornerRadius: 4) {
                            viewModel.appState.navigation.pop()
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
        .navigationBarBackButtonHidden()
    }
}

extension ForgotPasswordView {
    @MainActor
    final class ViewModel: BaseViewModel, ObservableObject {
        func sendEmailCode() async {
            
        }
    }
}
