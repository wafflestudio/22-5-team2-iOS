//
//  SplashViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import Foundation

final class SplashViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var isLoggedIn: Bool = false
    
    func checkLogin() {
        isLoading = true
        
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
