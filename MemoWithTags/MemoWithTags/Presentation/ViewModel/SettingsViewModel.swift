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
            router.reset()
            router.push(to: .root)
        case .failure(let error):
            appState.system.isShowingAlert = true
            appState.system.errorMessage = error.localizedDescription()
        }
    }
}
