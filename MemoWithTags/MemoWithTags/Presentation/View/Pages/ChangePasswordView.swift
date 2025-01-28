//
//  ChangePasswordView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/27/25.
//

import SwiftUI

struct ChangePasswordView: View {
    @ObservedObject var viewModel: ViewModel
    
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var newPasswordRepeat: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                SecureField (
                    "",
                    text: $currentPassword,
                    prompt:
                        Text("기존 비밀번호")
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
                VStack(spacing: 4) {
                    SecureField(
                        "",
                        text: $newPassword,
                        prompt: Text("새 비밀번호")
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
                    
                    //조건 표시
                    HStack {
                        Spacer()
                        Text("\(newPassword.count)/8")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.dateGray)
                            .padding(.horizontal, 6)
                    }
                }
                
                //비밀번호 확인 필드
                SecureField(
                    "",
                    text: $newPasswordRepeat,
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
            
            Spacer()
            
            Button {
                Task {
                    
                }
            } label: {
                Text("완료")
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 12)
                
            }
            .background(currentPassword.isEmpty || newPassword.isEmpty || newPasswordRepeat.isEmpty ? Color(hex: "#E3E3E7") : Color.titleTextBlack)
            .cornerRadius(22)
            .disabled(currentPassword.isEmpty || newPassword.isEmpty || newPasswordRepeat.isEmpty)

        }
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .regular))
                    .onTapGesture {
                        viewModel.appState.navigation.pop()
                    }
            }
            
            ToolbarItem(placement: .navigation) {
                Text("비밀번호 변경")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.titleTextBlack)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

extension ChangePasswordView {
    @MainActor
    final class ViewModel: BaseViewModel, ObservableObject {

    }
}
