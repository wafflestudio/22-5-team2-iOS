//
//  DeepLinkHandler.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/22/25.
//

import Foundation

@MainActor
struct DeepLinkHandler {
    let appState: AppState
    let kakaoLoginUseCase: KakaoLoginUseCase
    
    func handle(url: URL) async {
        guard url.scheme == "memowithtags",
              url.host == "oauth",
              let service = url.pathComponents.last,
              let code = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == "code" })?.value
        else {
            appState.system.showAlert = true
            appState.system.errorMessage = "유효하지 않은 접근"
            return
        }
        
        do {
            switch service {
            case "kakao":
                let result = await kakaoLoginUseCase.execute(authCode: code)
                
                switch result {
                case .success:
                    appState.user.isLoggedIn = true
                    appState.navigation.push(to: .main)
                case .failure(let error):
                    appState.system.showAlert = true
                    appState.system.errorMessage = error.localizedDescription()
                }
            case "google":
                print("Google login successful")
            case "naver":
                print("Naver login successful")
            default:
                appState.system.showAlert = true
                appState.system.errorMessage = "유효하지 않은 접근"
            }
        }
    }
}