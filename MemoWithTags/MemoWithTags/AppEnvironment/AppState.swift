//
//  AppState.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/12/25.
//

import SwiftUI
import Combine

///전역적으로 app 전체의 상태를 저장
@MainActor
struct AppState {
    @ObservedObject var system: SystemState
    @ObservedObject var navigation: NavigationState
}
