//
//  EmailVerificationViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import SwiftUI

@MainActor
final class EmailVerificationViewModel: BaseViewModel, ObservableObject {
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
        
        if code == "000000" {
            appState.navigation.push(to: .signupSuccess)
        } else {
            appState.system.showAlert = true
            appState.system.errorMessage = VerifyEmailError.notMatchCode.localizedDescription()
        }
        
    }
}
