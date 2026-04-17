import Dependencies
import Foundation

public struct ItemService: TestDependencyKey {
    public var fetchItems: @Sendable () async throws -> [Item]
    public var fetchDetail: @Sendable (String) async throws -> String

    public static let liveValue = ItemService(
        fetchItems: {
            let (data, _) = try await URLSession.shared.data(
                from: URL(string: "https://api.example.com/items")!
            )
            return try JSONDecoder().decode([Item].self, from: data)
        },
        fetchDetail: { id in
            let (data, _) = try await URLSession.shared.data(
                from: URL(string: "https://api.example.com/items/\(id)/detail")!
            )
            return String(data: data, encoding: .utf8) ?? ""
        }
    )

    public static let testValue = ItemService(
        fetchItems: unimplemented("ItemService.fetchItems"),
        fetchDetail: unimplemented("ItemService.fetchDetail")
    )
}

extension DependencyValues {
    public var itemService: ItemService {
        get { self[ItemService.self] }
        set { self[ItemService.self] = newValue }
    }
}
