//
//  SplashViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import Foundation

@MainActor
final class SplashViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var isLoggedIn: Bool = false
    
    func checkLogin() {
        Task {
            isLoading = true
            
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 일부러 1초 딜레이
            
            guard let _ = KeyChainManager.shared.readAccessToken(),
                  let _ = KeyChainManager.shared.readRefreshToken() else {
                isLoading = false
                isLoggedIn = false
                return
            }
            
            isLoading = false
            isLoggedIn = true
        }
    }
}
