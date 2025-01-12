//
//  Untitled.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/9/25.
//

import SwiftUI

enum Route: Hashable {
    //page 설정
    case root
    case main
    case login
    case signup
    case emailVerification(email: String)
    case signupSuccess
    case settings
    case search
}

@MainActor
final class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()

    func push(to route: Route) {
        path.append(route)
    }
        
    func pop() {
        path.removeLast()
    }
    
    func reset() {
        path.removeLast(path.count)
    }
}
