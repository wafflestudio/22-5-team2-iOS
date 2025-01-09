//
//  EmailVerificationViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import SwiftUI

@MainActor
final class EmailVerificationViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isVerified: Bool = false
    
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private let emailVerificationUseCase = DefaultEmailVerificationUseCase(authRepository: DefaultAuthRepository.shared)
    
    func verify(email: String, code: String) async {
        isVerified = false
        isLoading = true
        
        let result = await emailVerificationUseCase.execute(email: email, code: code)
        isLoading = false
        
        switch result {
        case .success:
            isVerified = true
            showAlert = false
        case .failure(let error):
            isVerified = true
            showAlert = false
            errorMessage = error.localizedDescription()
        }
    }
}
