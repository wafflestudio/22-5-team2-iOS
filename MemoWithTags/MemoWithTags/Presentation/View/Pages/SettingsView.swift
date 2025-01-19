//
//  SettingsView.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/5/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.backgroundGray
                .ignoresSafeArea()
            
            List {
                VStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 30))
                        .padding(10)
                        .foregroundStyle(Color.white)
                        .background(Color.searchBarBackgroundGray)
                        .clipShape(Circle())
                    
                    if viewModel.appState.user.userName != nil || viewModel.appState.user.userEmail != nil {
                        Text(viewModel.appState.user.userName!)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color.titleTextBlack)
                        
                        Text(viewModel.appState.user.userEmail!)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.black.opacity(0.5))
                    } else {
                        RoundedRectangle(cornerRadius: 14).frame(width: 80, height: 20)
                            .foregroundStyle(.black.opacity(0.05))
                        RoundedRectangle(cornerRadius: 14).frame(width: 150, height: 20)
                            .foregroundStyle(.black.opacity(0.05))
                    }
                    
                    
                }
                .padding(.top, 60)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
                Section {
                    CustomCell(icon: "person.crop.circle.fill", text: "프로필 수정") {
                        
                    }
                    
                    CustomCell(icon: "lock.fill", text: "비밀번호 재설정") {
                        Task {
                            viewModel.appState.navigation.push(to: .forgotPassword)
                        }
                    }
                    
                    CustomCell(icon: "arrowshape.turn.up.backward.fill", text: "로그아웃", color: Color.red) {
                        Task {
                            await viewModel.logout()
                        }
                    }
                    
                } header: {
                    Text("계정")
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                
                //메모 관리
                Section {
                    CustomCell(icon: "text.page.fill", text: "잠긴 메모") {
                        
                    }
                    
                } header: {
                    Text("메모 관리")
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                //태그 관리
                Section {
                    CustomCell(icon: "tag.fill", text: "전체 태그") {
                        
                    }
                    
                } header: {
                    Text("태그 관리")
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .listRowSpacing(10)
            .scrollContentBackground(.hidden)
            .padding(.horizontal, 14)
        }
        .onAppear {
            Task {
                await viewModel.getUserInfo()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18))
                    .onTapGesture {
                        viewModel.appState.navigation.pop()
                    }
            }
            
            ToolbarItem(placement: .navigation) {
                Text("Settings")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.titleTextBlack)
            }
        }
    }
    
    
    @ViewBuilder private func CustomCell(icon: String, text: String, color: Color? = Color.titleTextBlack, onTap: (() -> Void)?) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(.black.opacity(0.5))
            
            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(color)
            
            Spacer()
            
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 18)
        .background(Color.memoBackgroundWhite)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
        .onTapGesture {
            onTap?()
        }
    }
}
