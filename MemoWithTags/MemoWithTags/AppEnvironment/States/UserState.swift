//
//  UserState.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/14/25.
//

import SwiftUI

@MainActor
final class UserState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    @Published var userName: String?
    @Published var userEmail: String?
}
