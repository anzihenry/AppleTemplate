import Foundation
import SwiftData

public enum AppDatabase {
    public static func makeContainer() throws -> ModelContainer {
        let schema = Schema([PersistentItem.self])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }
}
