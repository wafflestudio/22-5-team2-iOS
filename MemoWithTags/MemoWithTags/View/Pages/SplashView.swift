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
        if viewModel.isLoading {
            Text("Loading...")
        } else {
            if viewModel.isLoggedIn {
                MainView()
            } else {
                LoginView()
            }
        }
    }
}
