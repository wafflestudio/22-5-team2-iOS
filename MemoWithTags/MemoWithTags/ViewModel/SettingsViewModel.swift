//
//  SettingsViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/9/25.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isLoggedOut: Bool = false
    
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private let logoutUseCase = DefaultLogoutUseCase(authRepository: DefaultAuthRepository.shared)
    
    func logout() async {
        isLoggedOut = false
        isLoading = true
        
        let result = await logoutUseCase.execute()
        isLoading = false
        
        switch result {
        case .success:
            isLoggedOut = true
            showAlert = false
        case .failure(let error):
            isLoggedOut = false
            showAlert = true
            errorMessage = error.localizedDescription()
        }
    }
}
