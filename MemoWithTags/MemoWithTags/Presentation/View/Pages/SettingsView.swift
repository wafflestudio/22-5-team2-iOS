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
            
            VStack {
                
                CustomSection {
                    HStack {
                        Circle()
                            .fill(Color.searchBarBackgroundGray)
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text("writer")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.titleTextBlack)
                            
                            Text("email@email.com")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color.titleTextBlack)
                        }
                    }
                }
                
                CustomSection {
                    Text("비밀번호 재설정")
                        .onTapGesture {
                        }
                }
                
                CustomSection {
                    Text("로그아웃")
                        .onTapGesture {
                            Task {
                                await viewModel.logout()
                            }
                        }
                }
            }
            .padding(.horizontal, 12)
        }
        .onAppear {
            Task {
                if viewModel.appState.user.current == nil {
                    await viewModel.getUserInfo()
                }
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
    
    
    @ViewBuilder private func CustomSection(content: () -> some View) -> some View {
        VStack(alignment: .leading) {
            content()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .frame(maxWidth: .infinity)
        .background(Color.memoBackgroundWhite)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
    }
}
