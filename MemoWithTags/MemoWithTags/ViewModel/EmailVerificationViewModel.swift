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
//        isLoading = true
//        
//        let result = await emailVerificationUseCase.execute(email: email, code: code)
//
//        switch result {
//        case .success:
//            isVerified = true
//            showAlert = false
//        case .failure(let error):
//            isVerified = false
//            showAlert = true
//            errorMessage = error.localizedDescription()
//        }
//        isLoading = false
        
        isLoading = true
        
        if code == "250110" {
            isVerified = true
            showAlert = false
        } else {
            isVerified = false
            showAlert = true
            errorMessage = "인증코드가 올바르지 않습니다."
        }
        
        isLoading = false
    }
}
