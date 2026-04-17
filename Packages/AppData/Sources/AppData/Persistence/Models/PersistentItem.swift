import Foundation
import SwiftData

@Model
public final class PersistentItem {
    @Attribute(.unique) public var id: String
    public var title: String
    public var subtitle: String
    public var createdAt: Date

    public init(id: String, title: String, subtitle: String, createdAt: Date = .now) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.createdAt = createdAt
    }
}
