//
//  DIContainer.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/12/25.
//

import Foundation
import SwiftUI
///의존성 주입을 한번에 처리하는 컨테이너
struct DIContainer {
    @ObservedObject var appState: AppState
    @ObservedObject var router: NavigationRouter
    let useCases: UseCases
    
    init(appState: AppState, router: NavigationRouter) {
        self.appState = appState
        self.router = router
        
        let repositories = DIContainer.configureRepositories()
        self.useCases = DIContainer.configureUseCases(repositories: repositories)
    }
}

extension DIContainer {
    struct UseCases {
        let signupUseCase: SignupUseCase
        let loginUseCase: LoginUseCase
        let logoutUseCase: LogoutUseCase
        let emailVerificationUseCase: EmailVerificationUseCase
        let forgotPasswordUseCase: ForgotPasswordUseCase
        let resetPasswordUseCase: ResetPasswordUseCase
        let socialLoginUseCase: SocialLoginUseCase
        
        let createMemoUseCase: CreateMemoUseCase
        let updateMemoUseCase: UpdateMemoUseCase
        let deleteMemoUseCase: DeleteMemoUseCase
        let fetchMemoUseCase: FetchMemoUseCase
        
        let createTagUseCase: CreateTagUseCase
        let updateTagUseCase: UpdateTagUseCase
        let deleteTagUseCase: DeleteTagUseCase
        let fetchTagUseCase: FetchTagUseCase
    }
}

extension DIContainer {
    struct Repositories {
        let authRepository: AuthRepository
        let memoRepository: MemoRepository
        let tagRepository: TagRepository
    }
}

extension DIContainer {
    private static func configureRepositories() -> Repositories {
        let authRepository = DefaultAuthRepository()
        let memoRepository = DefaultMemoRepository()
        let tagRepository = DefaultTagRepository()
        
        return .init(authRepository: authRepository, memoRepository: memoRepository, tagRepository: tagRepository)
    }
}

extension DIContainer {
    private static func configureUseCases(repositories: Repositories) -> UseCases {
        let signupUseCase = DefaultSignupUseCase(authRepository: repositories.authRepository)
        let loginUseCase = DefaultLoginUseCase(authRepository: repositories.authRepository)
        let logoutUseCase = DefaultLogoutUseCase(authRepository: repositories.authRepository)
        let emailVerificationUseCase = DefaultEmailVerificationUseCase(authRepository: repositories.authRepository)
        let forgotPasswordUseCase = DefaultForgotPasswordUseCase(authRepository: repositories.authRepository)
        let resetPasswordUseCase = DefaultResetPasswordUseCase(authRepository: repositories.authRepository)
        let socialLoginUseCase: DefaultSocialLoginUseCase = DefaultSocialLoginUseCase(authRepository: repositories.authRepository)
        
        let createMemoUseCase = DefaultCreateMemoUseCase(memoRepository: repositories.memoRepository)
        let updateMemoUseCase = DefaultUpdateMemoUseCase(memoRepository: repositories.memoRepository)
        let deleteMemoUseCase = DefaultDeleteMemoUseCase(memoRepository: repositories.memoRepository)
        let fetchMemoUseCase = DefaultFetchMemoUseCase(memoRepository: repositories.memoRepository)
        
        let createTagUseCase = DefaultCreateTagUseCase(tagRepository: repositories.tagRepository)
        let updateTagUseCase = DefaultUpdateTagUseCase(tagRepository: repositories.tagRepository)
        let deleteTagUseCase = DefaultDeleteTagUseCase(tagRepository: repositories.tagRepository)
        let fetchTagUseCase = DefaultFetchTagUseCase(tagRepository: repositories.tagRepository)
        
        return .init (
            signupUseCase: signupUseCase,
            loginUseCase: loginUseCase,
            logoutUseCase: logoutUseCase,
            emailVerificationUseCase: emailVerificationUseCase,
            forgotPasswordUseCase: forgotPasswordUseCase,
            resetPasswordUseCase: resetPasswordUseCase,
            socialLoginUseCase: socialLoginUseCase,
            createMemoUseCase: createMemoUseCase,
            updateMemoUseCase: updateMemoUseCase,
            deleteMemoUseCase: deleteMemoUseCase,
            fetchMemoUseCase: fetchMemoUseCase,
            createTagUseCase: createTagUseCase,
            updateTagUseCase: updateTagUseCase,
            deleteTagUseCase: deleteTagUseCase,
            fetchTagUseCase: fetchTagUseCase
        )
    }
}
