//
//  ResetPasswordViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/17/25.
//

import Foundation

@MainActor
final class ResetPasswordViewModel: BaseViewModel, ObservableObject {
    @Published var satisfiedCount: Int = 0
    @Published var isValidPassword: Bool = false
    
    ///정규식으로 비밀번호 형식 검사
    func checkPasswordValidity(password: String) {
        let isValidLength = password.count >= 8
        let containsUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let containsLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let containsNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        let containsSpecialCharacter = password.range(of: "[!@#$%^&*?_+=-]", options: .regularExpression) != nil
        
        satisfiedCount = [isValidLength, containsUppercase, containsLowercase, containsNumber, containsSpecialCharacter].filter { $0 }.count
        
        isValidPassword = isValidLength && containsUppercase && containsLowercase && containsNumber && containsSpecialCharacter
    }
    
    func resetPassword(email: String, password: String, passwordRepeat: String, code: String) async {
        checkPasswordValidity(password: password)
        let isPasswordSame = password == passwordRepeat
        
        if !isValidPassword {
            appState.system.showAlert = true
            appState.system.errorMessage = ResetPasswordError.invalidPassword.localizedDescription()
        } else if !isPasswordSame {
            appState.system.showAlert = true
            appState.system.errorMessage = ResetPasswordError.passwordNotMatch.localizedDescription()
        } else {
            let result = await useCases.resetPasswordUseCase.execute(email: email, code: code, newPassword: password)
            
            switch result {
            case .success:
                appState.navigation.push(to: .resetPasswordSuccess)
            case .failure(let error):
                appState.system.showAlert = true
                appState.system.errorMessage = error.localizedDescription()
            }
        }
    }
}
