import SwiftUI
import ComposableArchitecture
import AppCore

@main
struct AppleTemplate_watchOS: App {
    var store: StoreOf<AppFeature> {
        Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    }

    var body: some Scene {
        WindowGroup {
            HomeView(
                store: store.scope(
                    state: \.home,
                    action: \.home
                )
            )
        }
    }
}
