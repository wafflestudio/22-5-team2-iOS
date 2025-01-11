//
//  MemoWithTagsApp.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//

import SwiftUI

@main
struct MemoWithTagsApp: App {
    @StateObject private var router = NavigationRouter()
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(router)
        }
    }
}
