//
//  LoginView.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        ZStack {
            Color.backgroundGray.edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    //---------------email text field---------------
                    VStack(alignment: .leading, spacing: 2) {
                        Text("email")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.black)
                            .padding(.horizontal, 7)
                        
                        TextField("", text: $email, prompt: Text("\("example@email.com")")
                            .font(.system(size: 16, weight: .regular))
                        )
                        .padding(14)
                        .font(.system(size: 16, weight: .regular))
                        .background(Color.backgroundGray)
                        .cornerRadius(14)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    }
                    
                    //---------------password text field---------------
                    VStack(alignment: .leading, spacing: 2) {
                        Text("password")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.black)
                            .padding(.horizontal, 7)
                        
                        SecureField("", text: $password, prompt: Text("****************")
                            .font(.system(size: 16, weight: .regular))
                        )
                        .padding(14)
                        .font(.system(size: 16, weight: .regular))
                        .background(Color.backgroundGray)
                        .cornerRadius(14)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    }
                    
                    //---------------Login button---------------
                    Button {
                        //action
                    } label: {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)

                    }
                    .background(.black)
                    .cornerRadius(30)
                    .padding(.horizontal, 20)
                    
                    //---------------비밀번호 찾기---------------
                    Divider()
                    
                    HStack {
                        Text("Forgot password?")
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                    }
                    .padding(.horizontal, 4)
                    .onTapGesture {
                        //action
                    }
                    
                    //---------------회원가입---------------
                    Divider()
                    
                    HStack {
                        Text("Don't have an account?")
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                    }
                    .padding(.horizontal, 4)
                    .onTapGesture {
                        //action
                    }

                    
                    //---------------구글로 가입---------------
                    Divider()
                    
                    HStack {
                        Text("Or...")
                        Spacer()
                        Button {
                            //action
                        } label: {
                            Text("Continue with Google")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                        }
                        .border(Color(white: 30/255, opacity: 0.1))
                    }
                    .padding(.horizontal, 4)
                    
                    //태그는 이후에 추가
                }
                .padding(14)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 14)
            .shadow(color: Color(white: 0, opacity: 0.06), radius: 6, x: 0, y: 2)

        }
        
    }
}

#Preview {
    LoginView()
}
