//
//  Error.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/2/25.
//
import Foundation

enum LoginError: Error {
    case invalidCreditentials
    case networkError
    case unknown
    case tokenSaveError
    case invalidEmail
    
    func localizedDescription() -> String {
        switch self {
        case .invalidCreditentials: return "이메일 또는 비밀번호가 잘못되었습니다."
        case .networkError: return "Network error"
        case .unknown: return "Unknown error"
        case .tokenSaveError: return "Token save error"
        case .invalidEmail: return "이메일 형식이 잘못되었습니다."
        }
    }
    
    static func from(baseError: BaseError) -> LoginError {
        switch baseError {
        case .UNAUTHORIZED: return .invalidCreditentials
        case .INTERNAL_SERVER_ERROR: return .networkError
        default: return .unknown
        }
    }
}

enum LogoutError: Error {
    case tokenDeleteError
    
    func localizedDescription() -> String {
        switch self {
        case .tokenDeleteError: return "Token delete error"
        }
    }
}

enum RegisterError: Error {
    case emailAlreadyExists
    case networkError
    case unknown
    case invalidEmail
    case invalidPassword
    case passwordNotMatch
    
    func localizedDescription() -> String {
        switch self {
        case .emailAlreadyExists: return "이미 등록된 이메일입니다."
        case .networkError: return "Network error"
        case .unknown: return "Unknown error"
        case .invalidEmail: return "이메일 형식이 잘못되었습니다."
        case .invalidPassword: return "비밀번호 형식이 잘못되었습니다."
        case .passwordNotMatch: return "비밀번호가 일치하지 않습니다."
        }
    }
    
    static func from(baseError: BaseError) -> RegisterError {
        switch baseError {
        case .BAD_REQUEST: return .emailAlreadyExists
        case .INTERNAL_SERVER_ERROR: return .networkError
        default: return .unknown
        }
    }
}

enum ForgotPasswordError: Error {
    case UserNotFound
    case networkError
    case unknown
    case invalidEmail
    
    func localizedDescription() -> String {
        switch self {
        case .UserNotFound: return "사용자를 찾을 수 없습니다."
        case .networkError: return "Network error"
        case .unknown: return "Unknown error"
        case .invalidEmail: return "이메일 형식이 잘못되었습니다."
        }
    }
    
    static func from(baseError: BaseError) -> ForgotPasswordError {
        switch baseError {
        case .UNAUTHORIZED: return .UserNotFound
        case .INTERNAL_SERVER_ERROR: return .networkError
        default: return .unknown
        }
    }
}

enum ResetPasswordError: Error {
    case notMatchCode
    case networkError
    case unknown
    case invalidPassword
    case passwordNotMatch
    
    func localizedDescription() -> String {
        switch self {
        case .notMatchCode: return "인증코드가 올바르지 않습니다."
        case .networkError: return "Network error"
        case .unknown: return "Unknown error"
        case .invalidPassword: return "비밀번호 형식이 잘못되었습니다."
        case .passwordNotMatch: return "비밀번호가 일치하지 않습니다."
        }
    }
    
    static func from(baseError: BaseError) -> ResetPasswordError {
        switch baseError {
        case .UNAUTHORIZED: return .notMatchCode
        case .INTERNAL_SERVER_ERROR: return .networkError
        default: return .unknown
        }
    }
}

enum VerifyEmailError: Error {
    case notMatchCode
    case networkError
    case unknown
    case tokenSaveError
    
    func localizedDescription() -> String {
        switch self {
        case .notMatchCode: return "인증코드가 올바르지 않습니다."
        case .networkError: return "Network error"
        case .unknown: return "Unknown error"
        case .tokenSaveError: return "Token save error"
        }
    }
    
    static func from(baseError: BaseError) -> VerifyEmailError {
        switch baseError {
        case .UNAUTHORIZED: return .notMatchCode
        case .INTERNAL_SERVER_ERROR: return .networkError
        default: return .unknown
        }
    }
}

enum GetUserInfoError: Error {
    case UserNotFound
    case networkError
    case unknown
    
    func localizedDescription() -> String {
        switch self {
        case .UserNotFound: return "사용자를 찾을 수 없습니다."
        case .networkError: return "Network error"
        case .unknown: return "Unknown error"
        }
    }
    
    static func from(baseError: BaseError) -> GetUserInfoError {
        switch baseError {
        case .UNAUTHORIZED: return .UserNotFound
        case .INTERNAL_SERVER_ERROR: return .networkError
        default: return .unknown
        }
    }
}

enum SocialLoginError: Error {
    case invalidCode
    case networkError
    case unknown
    case tokenSaveError
    
    func localizedDescription() -> String {
        switch self {
        case .invalidCode: return "사용자를 불러오지 못했습니다."
        case .networkError: return "Network error"
        case .unknown: return "Unknown error"
        case .tokenSaveError: return "Token save error"
        }
    }
    
    static func from(baseError: BaseError) -> SocialLoginError {
        switch baseError {
        case .UNAUTHORIZED: return .invalidCode
        case .INTERNAL_SERVER_ERROR: return .networkError
        default: return .unknown
        }
    }
}

enum MemoError: Error {
    case wrongFormat
    case notSureUser
    case wrongUser
    case nonExistingMemo
    case serverError
    case invalidOrder
    case unknown
    
    func localizedDescription() -> String {
        switch self {
        case .wrongFormat: return "NO NO NO FUCK SWIFT AND IOS"
        case .notSureUser: return "Are you the right user????"
        case .wrongUser: return "EXISTING MEMO, WRONG USER"
        case .nonExistingMemo: return "NO MEMO"
        case .serverError: return "Spring 화이팅!!!"
        case .invalidOrder: return "WRONG ORDER!!!"
        case .unknown: return "memo WTF"
        }
    }
    
    static func from(baseError: BaseError) -> MemoError {
        switch baseError {
        case .BAD_REQUEST: return .wrongFormat
        case .UNAUTHORIZED: return .notSureUser
        case .FORBIDDEN: return .wrongUser
        case .NOT_FOUND: return .nonExistingMemo
        case .INTERNAL_SERVER_ERROR: return .serverError
        default: return .unknown
        }
    }
}

enum TagError: Error {
    case wrongFormat
    case notSureUser
    case wrongUser
    case nonExistingMemo
    case serverError
    case unknown
    
    func localizedDescription() -> String {
        switch self {
        case .wrongFormat: return "NO NO NO FUCK SWIFT AND IOS"
        case .notSureUser: return "Are you the right user????"
        case .wrongUser: return "EXISTING TAG, WRONG USER"
        case .nonExistingMemo: return "NO TAG"
        case .serverError: return "Spring 화이팅!!"
        case .unknown: return "tag WTF"
        }
    }
    
    static func from(baseError: BaseError) -> TagError {
        switch baseError {
        case .BAD_REQUEST: return .wrongFormat
        case .UNAUTHORIZED: return .notSureUser
        case .FORBIDDEN: return .wrongUser
        case .NOT_FOUND: return .nonExistingMemo
        case .INTERNAL_SERVER_ERROR: return .serverError
        default: return .unknown
        }
    }
}
