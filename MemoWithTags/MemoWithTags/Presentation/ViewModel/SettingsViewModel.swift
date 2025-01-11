//
//  SettingsViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/9/25.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private let logoutUseCase = DefaultLogoutUseCase(authRepository: DefaultAuthRepository.shared)
    
    func logout(router: NavigationRouter) async {
        let result = await logoutUseCase.execute()
        
        switch result {
        case .success:
            router.reset()
            router.push(to: .root)
        case .failure(let error):
            showAlert = true
            errorMessage = error.localizedDescription()
        }
    }
}
