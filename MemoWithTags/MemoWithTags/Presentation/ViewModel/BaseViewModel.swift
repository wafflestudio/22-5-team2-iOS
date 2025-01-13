//
//  BaseViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/13/25.
//

import Foundation

@MainActor
protocol BaseViewModelProtocol: Sendable {
    var container: DIContainer { get set }
    var appState: AppState { get }
    var useCases: DIContainer.UseCases { get }
}

class BaseViewModel: BaseViewModelProtocol {
    var container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    var appState: AppState {
        container.appState
    }
    
    var useCases: DIContainer.UseCases {
        container.useCases
    }
}
