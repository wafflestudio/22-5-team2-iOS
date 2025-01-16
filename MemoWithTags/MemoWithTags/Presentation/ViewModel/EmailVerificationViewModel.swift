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
        let result = await useCases.emailVerificationUseCase.execute(email: email, code: code)

        switch result {
        case .success:
            appState.navigation.push(to: .signupSuccess)
        case .failure(let error):
            appState.system.showAlert = true
            appState.system.errorMessage = error.localizedDescription()
        }
        
//        if code == "000000" {
//            appState.navigation.push(to: .signupSuccess)
//        } else {
//            appState.system.showAlert = true
//            appState.system.errorMessage = VerifyEmailError.notMatchCode.localizedDescription()
//        }
        
    }
}
