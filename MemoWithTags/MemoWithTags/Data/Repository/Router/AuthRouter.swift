//
//  AuthRouter.swift
//  MemoWithTags
//
//  Created by 최진모 on 1/4/25.
//

import Foundation
import Alamofire

enum AuthRouter: Router {
    case register(email: String, password: String)
    case login(email: String, password: String)
    case forgotPassword(email: String)
    case resetPassword(email: String, newPassword: String)
    case verifyEmail(email: String, code: String)
    case refreshToken(token: String)
    case getUserInfo
    
    var baseURL: URL {
        return URL(string: NetworkConfiguration.baseURL + "/auth")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .register, .login, .forgotPassword, .resetPassword, .verifyEmail, .refreshToken:
            return .post
        case .getUserInfo:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .register:
            return "/register"
        case .login:
            return "/login"
        case .forgotPassword:
            return "/forgot-password"
        case .resetPassword:
            return "/reset-password"
        case .verifyEmail:
            return "/verify-email"
        case .refreshToken:
            return "/refresh-token"
        case .getUserInfo:
            return "/me"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .register(email, password),
             let .login(email, password):
            return ["email": email, "password": password]
        case let .verifyEmail(email, code):
            return ["email": email, "verificationCode": code]
        case let .forgotPassword(email):
            return ["email": email]
        case let .resetPassword(email, newPassword):
            return ["email": email, "password": newPassword]
        case let .refreshToken(token):
            return ["refreshToken": token]
        case .getUserInfo:
            return nil
        }
    }
}
