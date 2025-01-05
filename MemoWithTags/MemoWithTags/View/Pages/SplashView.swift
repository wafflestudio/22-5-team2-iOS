//
//  SplashView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.isLoggedIn{
                MainView()
            } else {
                LoginView()
            }
        }
        .onAppear() {
            viewModel.checkLogin()
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.backgroundGray.edgesIgnoringSafeArea(.all)
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        }
    }
}

#Preview {
    SplashView()
}
