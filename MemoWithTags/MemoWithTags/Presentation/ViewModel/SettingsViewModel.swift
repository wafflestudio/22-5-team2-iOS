//
//  SettingsViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/9/25.
//

import Foundation

@MainActor
final class SettingsViewModel: BaseViewModel, ObservableObject {
    func logout() async {
        let result = await useCases.logoutUseCase.execute()
        
        switch result {
        case .success:
            appState.navigation.reset()
            appState.navigation.push(to: .root)
        case .failure(let error):
            appState.system.showAlert = true
            appState.system.errorMessage = error.localizedDescription()
        }
    }
}
