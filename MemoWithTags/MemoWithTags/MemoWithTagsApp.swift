//
//  MemoWithTagsApp.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//

import SwiftUI

@main
struct MemoWithTagsApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            Group {
                if appState.isLoading {
                    // 로딩 중일 때 표시할 뷰 (예: 스플래시 화면)
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    if appState.isLoggedIn {
                        // 로그인 상태일 때 메인 뷰 표시
                        MainView()
                    } else {
                        // 로그인 상태가 아닐 때 로그인 뷰 표시
                        LoginView()
                    }
                }
            }
            .environmentObject(appState) // 하위 뷰에서 AppState에 접근할 수 있도록 환경 객체로 주입
        }
    }
}
