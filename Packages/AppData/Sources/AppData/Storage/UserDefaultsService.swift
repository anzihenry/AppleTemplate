import Dependencies
import Foundation

public struct UserDefaultsService: TestDependencyKey {
    public var set: @Sendable (any Sendable, String) -> Void
    public var get: @Sendable (String) -> (any Sendable)?
    public var remove: @Sendable (String) -> Void

    public init(
        set: @escaping @Sendable (any Sendable, String) -> Void,
        get: @escaping @Sendable (String) -> (any Sendable)?,
        remove: @escaping @Sendable (String) -> Void
    ) {
        self.set = set
        self.get = get
        self.remove = remove
    }

    public static let liveValue = UserDefaultsService(
        set: { value, key in
            UserDefaults.standard.set(value, forKey: key)
        },
        get: { key in
            UserDefaults.standard.value(forKey: key)
        },
        remove: { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
    )

    public static let testValue = UserDefaultsService(
        set: unimplemented("UserDefaultsService.set"),
        get: unimplemented("UserDefaultsService.get"),
        remove: unimplemented("UserDefaultsService.remove")
    )
}

extension DependencyValues {
    public var userDefaultsService: UserDefaultsService {
        get { self[UserDefaultsService.self] }
        set { self[UserDefaultsService.self] = newValue }
    }
}
