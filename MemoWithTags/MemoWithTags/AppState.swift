//
//  AppState.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/2/25.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = true // 로딩 상태를 표시하기 위함

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository = DefaultAuthRepository.shared) {
        self.authRepository = authRepository
        Task {
            await self.checkLoginStatus()
        }
    }

    /// 자동 로그인 상태를 확인하고 갱신
    func checkLoginStatus() async {
        // Keychain에서 토큰을 불러옴
        if let _ = NetworkConfiguration.accessToken,
           let _ = NetworkConfiguration.refreshToken {
            // Access Token 갱신 시도
            let result = await authRepository.refreshAccessToken()
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.isLoggedIn = true
                case .failure(_):
                    self.isLoggedIn = false
                }
                self.isLoading = false
            }
        } else {
            DispatchQueue.main.async {
                self.isLoggedIn = false
                self.isLoading = false
            }
        }
    }
}

