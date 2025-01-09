//
//  SplashViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import Foundation

@MainActor
final class SplashViewModel: ObservableObject {
    
    func checkLogin(router: NavigationRouter) {
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 일부러 1초 딜레이
            
            guard let _ = KeyChainManager.shared.readAccessToken(),
                  let _ = KeyChainManager.shared.readRefreshToken() else {
                
                router.reset()
                router.push(to: .login)
                return
            }
            
            router.reset()
            router.push(to: .main)
        }
    }
}
