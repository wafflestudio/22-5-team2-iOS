//
//  UserRepository.swift
//  MemoWithTags
//
//  Created by 최진모 on 12/29/24.
//

import Foundation

protocol AuthRepository: BaseRepository {
    ///회원가입하는 함수.
    func register(email: String, password: String) async throws
    ///로그인하는 함수. email과 password를 받아 계정 토큰을 반환함
    func login(email: String, password: String) async throws -> AuthDto
    ///비밀번호 재설정 요청, 인증하는 함수
    func forgotPassword(email: String) async throws
    ///비밀번호 재설정하는 함수
    func resetPassword(email: String, newPassword: String) async throws
    ///이메일 인증하는 함수
    func verifyEmail(email: String, code: String) async throws -> AuthDto
    ///token refresh 함수
    func refreshToken(refreshToken: String) async throws -> AuthDto
    ///유저 정보 가져오는 함수
    func getUserInfo() async throws -> UserDto
}

