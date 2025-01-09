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

final class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()

    func push(to route: Route) {
        path.append(route)
        print(path.count)
    }
        
    func pop() {
        path.removeLast()
        print(path.count)
    }
    
    func reset() {
        path.removeLast(path.count)
        print(path.count)
    }
}
