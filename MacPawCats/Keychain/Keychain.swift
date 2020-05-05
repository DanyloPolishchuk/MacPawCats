//
//  Keychain.swift
//  MacPawCats
//
//  Created by Danylo Polishchuk on 29.04.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation
import Security

private let service: String = "MacPawCats"

enum Keychain {

    /// Does a certain item exist?
    static func exists(account: String) throws -> Bool {
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: false,
            ] as NSDictionary, nil)
        if status == errSecSuccess {
            return true
        } else if status == errSecItemNotFound {
            return false
        } else {
            throw Errors.keychainError
        }
    }
    
    /// Adds an item to the keychain.
    private static func add(value: Data, account: String) throws {
        let status = SecItemAdd([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            // Allow background access:
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData: value,
            ] as NSDictionary, nil)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    /// Updates a keychain item.
    private static func update(value: Data, account: String) throws {
        let status = SecItemUpdate([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            ] as NSDictionary, [
            kSecValueData: value,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    /// Stores a keychain item.
    static func set(value: Data, account: String) throws {
        if try exists(account: account) {
            try update(value: value, account: account)
        } else {
            try add(value: value, account: account)
        }
    }
    
    // If not present, returns nil. Only throws on error.
    static func get(account: String) throws -> Data? {
        var result: AnyObject?
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: true,
            ] as NSDictionary, &result)
        if status == errSecSuccess {
            return result as? Data
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw Errors.keychainError
        }
    }
    
    /// Delete a single item.
    static func delete(account: String) throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    /// Delete all items for my app. Useful on eg logout.
    static func deleteAll() throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.keychainError }
    }
    
    enum Errors: Error {
        case keychainError
    }
}

//    try Keychain.set(value: "FooBar".data(using: .utf8)!, account: "username")
//    try Keychain.set(value: "YadaYada".data(using: .utf8)!, account: "password")
//    let user = try Keychain.get(account: "username")
//    let pass = try Keychain.get(account: "password")
//    try Keychain.delete(account: "username")
//    try Keychain.deleteAll()
