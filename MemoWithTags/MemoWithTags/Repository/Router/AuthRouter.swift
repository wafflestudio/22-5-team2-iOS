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
    case logout
    case forgotPassword(email: String)
    case resetPassword(email: String, newPassword: String)
    case verifyEmail(email: String)
    
    var baseURL: URL {
        return URL(string: NetworkConfiguration.baseURL + "/auth")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .register, .login, .logout, .forgotPassword, .resetPassword, .verifyEmail:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .register:
            return "/register"
        case .login:
            return "/login"
        case .logout:
            return "/logout"
        case .forgotPassword:
            return "/forgot-password"
        case .resetPassword:
            return "/reset-password"
        case .verifyEmail:
            return "/verify-email"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .register(email, password),
             let .login(email, password):
            return ["email": email, "password": password]
        case let .forgotPassword(email),
             let .verifyEmail(email):
            return ["email": email]
        case let .resetPassword(email, newPassword):
            return ["email": email, "password": newPassword]
        case .logout:
            return nil
        }
    }
}
