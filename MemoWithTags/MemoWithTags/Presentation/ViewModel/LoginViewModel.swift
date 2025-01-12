//
//  LoginViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//

import Foundation

@MainActor
final class LoginViewModel: BaseViewModel, ObservableObject {
    ///정규식으로 이메일 형식 검사
    func checkEmailValidity(email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func login(email: String, password: String) async {
        if !checkEmailValidity(email: email) {
            appState.showAlert = true
            appState.errorMessage = LoginError.invalidEmail.localizedDescription()
            return
        }
        
        let result = await useCases.loginUseCase.execute(email: email, password: password)

        switch result {
        case .success:
            router.push(to: .main)
        case .failure(let error):
            appState.showAlert = true
            appState.errorMessage = error.localizedDescription()
        }
    }
}
