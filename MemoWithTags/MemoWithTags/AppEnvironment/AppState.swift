//
//  AppState.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/12/25.
//

import Foundation

///전역적으로 app 전체의 상태를 저장
@MainActor
final class AppState: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
}
