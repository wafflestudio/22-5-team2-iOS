//
//  ErrorState.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/12/25.
//

import Foundation

final class SystemState {
    @Published var isShowingAlert: Bool = false
    @Published var errorMessage: String = ""
}
