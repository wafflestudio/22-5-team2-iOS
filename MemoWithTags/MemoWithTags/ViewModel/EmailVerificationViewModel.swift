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
    
    private let emailVerificationUseCase = DefaultEmailVerificationUseCase(authRepository: DefaultAuthRepository.shared)
    
    func verifiy(email: String, code: String) async {
        isLoading = true
        
        let result = await emailVerificationUseCase.execute(email: email, code: code)
        isLoading = false
        
        switch result {
        case .success:
            isVerified = true
        case .failure:
            isVerified = false
        }
    }
}
