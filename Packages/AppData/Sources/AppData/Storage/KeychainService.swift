import Dependencies
import Foundation
import Security

public struct KeychainService: TestDependencyKey {
    public var save: @Sendable (String, Data) throws -> Void
    public var load: @Sendable (String) throws -> Data?
    public var delete: @Sendable (String) throws -> Void

    public init(
        save: @escaping @Sendable (String, Data) throws -> Void,
        load: @escaping @Sendable (String) throws -> Data?,
        delete: @escaping @Sendable (String) throws -> Void
    ) {
        self.save = save
        self.load = load
        self.delete = delete
    }

    public static let liveValue = KeychainService(
        save: { key, data in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data,
            ]
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else {
                throw KeychainError.saveFailed(status)
            }
        },
        load: { key in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: true,
                kSecMatchLimit as String: kSecMatchLimitOne,
            ]
            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            guard status == errSecSuccess else {
                if status == errSecItemNotFound { return nil }
                throw KeychainError.loadFailed(status)
            }
            return result as? Data
        },
        delete: { key in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
            ]
            let status = SecItemDelete(query as CFDictionary)
            guard status == errSecSuccess || status == errSecItemNotFound else {
                throw KeychainError.deleteFailed(status)
            }
        }
    )

    public static let testValue = KeychainService(
        save: unimplemented("KeychainService.save"),
        load: unimplemented("KeychainService.load"),
        delete: unimplemented("KeychainService.delete")
    )
}

public enum KeychainError: Error {
    case saveFailed(OSStatus)
    case loadFailed(OSStatus)
    case deleteFailed(OSStatus)
}

extension DependencyValues {
    public var keychainService: KeychainService {
        get { self[KeychainService.self] }
        set { self[KeychainService.self] = newValue }
    }
}
