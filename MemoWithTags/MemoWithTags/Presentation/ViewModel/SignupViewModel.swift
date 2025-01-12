//
//  SignupViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/2/25.
//

import Foundation

@MainActor
final class SignupViewModel: BaseViewModel, ObservableObject {
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
    
    ///정규식으로 이메일 형식 검사
    func checkEmailValidity(email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func signup(email: String, password: String, passwordRepeat: String) async {
        let isEmailValid = checkEmailValidity(email: email)
        let isPasswordSame = password == passwordRepeat
        
        if !isEmailValid {
            appState.showAlert = true
            appState.errorMessage = RegisterError.invalidEmail.localizedDescription()
        } else if !isValidPassword {
            appState.showAlert = true
            appState.errorMessage = RegisterError.invalidPassword.localizedDescription()
        } else if !isPasswordSame {
            appState.showAlert = true
            appState.errorMessage = RegisterError.passwordNotMatch.localizedDescription()
        } else {
            let result = await useCases.signupUseCase.execute(email: email, password: password)
            
            switch result {
            case .success:
                router.push(to: .emailVerification(email: email))
            case .failure(let error):
                appState.showAlert = true
                appState.errorMessage = error.localizedDescription()
            }
        }
    }
}
