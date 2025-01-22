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
    case resetPassword(email: String, code: String, newPassword: String)
    case verifyEmail(email: String, code: String)
    case refreshToken(token: String)
    case getUserInfo
    case kakaoLogin(authCode: String)
    case naverLogin(authCode: String)
    case googleLogin(authCode: String)
    
    var baseURL: URL {
        switch self {
        case .kakaoLogin, .naverLogin, .googleLogin:
            return URL(string: NetworkConfiguration.baseURL + "/oauth")!
        default:
            return URL(string: NetworkConfiguration.baseURL + "/auth")!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register, .login, .forgotPassword, .resetPassword, .verifyEmail, .refreshToken:
            return .post
        case .getUserInfo, .kakaoLogin, .naverLogin, .googleLogin:
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
        case .kakaoLogin:
            return "/kakao/login"
        case .googleLogin:
            return "/google"
        case .naverLogin:
            return "/naver"
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
        case let .resetPassword(email, code, newPassword):
            return ["email": email, "verificationCode": code, "password": newPassword]
        case let .refreshToken(token):
            return ["refreshToken": token]
        case .getUserInfo:
            return nil
        case let .kakaoLogin(code), let .googleLogin(code), let .naverLogin(code):
            return ["code": code]
        }
    }
}
