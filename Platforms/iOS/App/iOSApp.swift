import SwiftUI
import ComposableArchitecture
import AppCore

@main
struct AppleTemplate_iOS: App {
    var store: StoreOf<AppFeature> {
        Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        TabView(selection: $store.selectedTab) {
            HomeView(
                store: store.scope(
                    state: \.home,
                    action: \.home
                )
            )
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(AppTab.home)

            SettingsView(
                store: store.scope(
                    state: \.settings,
                    action: \.settings
                )
            )
            .tabItem {
                Label("Settings", systemImage: "gear.fill")
            }
            .tag(AppTab.settings)
        }
    }
}
