//
//  EmailVerificationView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/6/25.
//

import SwiftUI

struct EmailVerificationView: View {
    @EnvironmentObject private var router: NavigationRouter
    @StateObject private var viewModel = EmailVerificationViewModel()
    
    let email: String
    
    @State private var code: String = ""
    
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
                    Text("이메일로 발송된 인증번호를 입력해주세요.")
                        .padding(.vertical, 8)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(Color.titleTextBlack)
                    
                    // 인증 코드 입력란
                    SeparatedTextField(length: 6, value: $code)
                        .padding(.top, 8)
                    
                    Button {
                        //action
                        Task {
                            await viewModel.verify(email: email, code: code)
                            
                            if !viewModel.isLoading && viewModel.isVerified{
                                router.push(to: .login)
                            }
                        }
                        
                    } label: {
                        Text("다음")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)

                    }
                    .background(code.count < 6 ? Color(hex: "#E3E3E7") : Color.titleTextBlack)
                    .cornerRadius(22)
                    .padding(.top, 16)
                    .disabled(code.count < 6)
                    
                    HStack(spacing: 8) {
                        Tag(text: "이전", size: 14, color: .init(hex: "#E3E3E7")) {
                            router.pop()
                        }
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.highlightRed)
                            .frame(width: 12, height: 24)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.highlightRed)
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

struct CharacterField: View {
    @Binding var character: String
    @FocusState var isFocused: Bool

    var onChange: (_ newValue: String) -> Void

    var body: some View {
        TextField("", text: $character)
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .frame(width: 36, height: 52)
            .font(.system(size: 22, weight: .semibold))
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(hex: "#181E2226"), lineWidth: 1)
            )
            .onChange(of: character) { oldValue, newValue in
                if newValue.count > 1 {
                    character = String(newValue.prefix(1)) // 첫 글자만 유지
                }
                onChange(character)
            }
            .focused($isFocused)
    }
}

struct SeparatedTextField: View {
    var length: Int
    @Binding var value: String
    
    @FocusState private var focusedIndex: Int?
    @State private var characters: [String]
    
    init(length: Int, value: Binding<String>) {
        self.length = length
        self._value = value
        self._characters = State(initialValue: Array(repeating: "", count: length))
    }
    
    var body: some View {
        HStack(spacing: 7) {
            ForEach(0..<length, id: \.self) { index in
                CharacterField(character: $characters[index]) { newValue in
                    handleInputChange(for: index, with: newValue)
                }
                .focused($focusedIndex, equals: index)
            }
        }
        .onAppear {
            focusedIndex = 0 // 첫 번째 필드에 포커스
        }
    }
    
    /// 입력값 변경 처리
    private func handleInputChange(for index: Int, with newValue: String) {
        characters[index] = newValue
        value = characters.joined() // 전체 문자열 업데이트
        
        if !newValue.isEmpty {
            if index < length - 1 {
                focusedIndex = index + 1 // 다음 필드로 포커스 이동
            } else {
                focusedIndex = nil // 마지막 필드에서 포커스 해제
            }
        } else if index > 0 {
            focusedIndex = index - 1 // 이전 필드로 포커스 이동
        }
    }
}
