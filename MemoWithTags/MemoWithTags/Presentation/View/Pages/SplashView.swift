//
//  SplashView.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/9/25.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var viewModel: SplashViewModel
    
    var body: some View {
        ZStack {
            Color.backgroundGray.edgesIgnoringSafeArea(.all)
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.checkLogin()
        }
    }
}
