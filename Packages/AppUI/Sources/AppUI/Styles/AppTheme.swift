import SwiftUI

public enum AppTheme {
    case system
    case light
    case dark

    public var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

extension Color {
    public static let appPrimary = Color("AppPrimary", bundle: .module)
    public static let appSecondary = Color("AppSecondary", bundle: .module)
    public static let appAccent = Color("AppAccent", bundle: .module)
    public static let appBackground = Color("AppBackground", bundle: .module)
}

extension View {
    public func appCardStyle() -> some View {
        modifier(CardStyleModifier())
    }

    public func appShimmer(when isLoading: Bool) -> some View {
        modifier(ShimmerModifier(isActive: isLoading))
    }
}
