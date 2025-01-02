//
//  AuthErrors.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/2/25.
//

import Foundation

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
    case userNotFound
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

enum RefreshError: Error {
    case invalidRefreshToken
    case networkError
    case unknown
}

extension LoginError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password."
        case .networkError:
            return "Network error. Please try again."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

extension LogoutError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network error. Please try again."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

extension RegisterError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emailAlreadyExists:
            return "This email is already registered."
        case .invalidEmail:
            return "Invalid email format."
        case .networkError:
            return "Network error. Please try again."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

extension ForgotPasswordError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email format."
        case .userNotFound:
            return "No user found with this email."
        case .networkError:
            return "Network error. Please try again."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

extension ResetPasswordError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidPassword:
            return "Invalid password format."
        case .networkError:
            return "Network error. Please try again."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

extension VerifyEmailError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emailNotFound:
            return "Email not found."
        case .networkError:
            return "Network error. Please try again."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

extension RefreshError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRefreshToken:
            return "Invalid refresh token."
        case .networkError:
            return "Network error. Please try again."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
