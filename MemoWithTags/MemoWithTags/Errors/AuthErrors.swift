//
//  AuthErrors.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/2/25.
//

enum LoginError: Error {
    case invalidCredentials
    case networkError
    case unknown
}

enum LogoutError: Error {
    case networkError
    case unknown
}

enum RegisterError: Error {
    case emailAlreadyExists
    case invalidEmail
    case networkError
    case unknown
}

enum ForgotPasswordError: Error {
    case invalidEmail
    case UserNotFound
    case networkError
    case unknown
}

enum ResetPasswordError: Error {
    case invalidPassword
    case networkError
    case unknown
}

enum VerifyEmailError: Error {
    case emailNotFound
    case networkError
    case unknown
}
