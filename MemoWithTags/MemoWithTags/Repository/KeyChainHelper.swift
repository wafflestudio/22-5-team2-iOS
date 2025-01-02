//
//  KeyChainHelper.swift
//  MemoWithTags
//
//  Created by Swimming Ryu on 1/2/25.
//

import Foundation
import Security

class KeychainHelper {
    
    static let shared = KeychainHelper()
    
    private init() {}
    
    /// Keychain에 Access Token 저장
    func saveAccessToken(token: String) -> Bool {
        let service = "com.memoWithTags.service"
        let account = "accessToken"
        guard let data = token.data(using: .utf8) else { return false }
        return save(service: service, account: account, data: data)
    }
    
    /// Keychain에 Refresh Token 저장
    func saveRefreshToken(token: String) -> Bool {
        let service = "com.memoWithTags.service"
        let account = "refreshToken"
        guard let data = token.data(using: .utf8) else { return false }
        return save(service: service, account: account, data: data)
    }
    
    /// Keychain에서 Access Token 불러오기
    func readAccessToken() -> String? {
        let service = "com.memoWithTags.service"
        let account = "accessToken"
        guard let data = read(service: service, account: account) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Keychain에서 Refresh Token 불러오기
    func readRefreshToken() -> String? {
        let service = "com.memoWithTags.service"
        let account = "refreshToken"
        guard let data = read(service: service, account: account) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Keychain에서 Access Token 삭제하기
    func deleteAccessToken() -> Bool {
        let service = "com.memoWithTags.service"
        let account = "accessToken"
        return delete(service: service, account: account)
    }
    
    /// Keychain에서 Refresh Token 삭제하기
    func deleteRefreshToken() -> Bool {
        let service = "com.memoWithTags.service"
        let account = "refreshToken"
        return delete(service: service, account: account)
    }
    
    /// Keychain에 데이터 저장
    private func save(service: String, account: String, data: Data) -> Bool {
        // 기존 항목 삭제
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        // 새 항목 추가
        let attributes = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ] as [String : Any]
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Keychain에서 데이터 불러오기
    func read(service: String, account: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String : Any]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        }
        return nil
    }
    
    /// Keychain에서 데이터 삭제
    func delete(service: String, account: String) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ] as [String : Any]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
