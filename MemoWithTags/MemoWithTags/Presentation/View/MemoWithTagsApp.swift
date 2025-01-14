//
//  MemoWithTagsApp.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//

import SwiftUI

@main
struct MemoWithTagsApp: App {
    
    @StateObject private var systemState = SystemState()
    @StateObject private var navigationState = NavigationState()
    
    var body: some Scene {
        WindowGroup {
            AppRootView(container: .init(
                appState: AppState(system: systemState, navigation: navigationState)
            ))
        }
    }
}
