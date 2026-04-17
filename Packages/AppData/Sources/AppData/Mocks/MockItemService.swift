import AppCore
import Foundation

public enum MockItemService {
    public static let sampleItems: [Item] = [
        Item(id: "1", title: "Getting Started", subtitle: "Learn the basics"),
        Item(id: "2", title: "Advanced Topics", subtitle: "Deep dive into features"),
        Item(id: "3", title: "Best Practices", subtitle: "Tips and tricks"),
        Item(id: "4", title: "API Reference", subtitle: "Complete documentation"),
        Item(id: "5", title: "Community", subtitle: "Join the discussion"),
    ]

    public static let success = ItemService(
        fetchItems: {
            try await Task.sleep(for: .seconds(0.5))
            return sampleItems
        },
        fetchDetail: { id in
            try await Task.sleep(for: .seconds(0.3))
            return "Detailed information for item \(id). This is mock data for testing purposes."
        }
    )

    public static let empty = ItemService(
        fetchItems: { [] },
        fetchDetail: { _ in "No details available" }
    )

    public static let failure = ItemService(
        fetchItems: { throw MockError.networkError },
        fetchDetail: { _ in throw MockError.networkError }
    )
}

public enum MockError: Error {
    case networkError
    case decodingError
}
