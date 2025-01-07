//
//  LoginViewModel.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/26/24.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isLoggedIn: Bool = false
    
    private let loginUseCase = DefaultSignupUseCase(authRepository: DefaultAuthRepository.shared)
    
    ///정규식으로 이메일 형식 검사
    func checkEmailValidity(email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func login(email: String, password: String) async {
        isLoading = true
        
        if !checkEmailValidity(email: email) {
            isLoading = false
            isLoggedIn = false
            return
        }
        
        let result = await loginUseCase.execute(email: email, password: password)
        isLoading = false
        
        switch result {
        case .success:
            isLoggedIn = true
        case .failure:
            isLoggedIn = false
        }
    }
}
