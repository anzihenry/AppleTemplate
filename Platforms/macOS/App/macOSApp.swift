import SwiftUI
import ComposableArchitecture
import AppCore

@main
struct AppleTemplate_macOS: App {
    var store: StoreOf<AppFeature> {
        Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)

        Settings {
            SettingsView(
                store: store.scope(
                    state: \.settings,
                    action: \.settings
                )
            )
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        NavigationSplitView {
            SidebarView(store: store)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
        } detail: {
            HomeView(
                store: store.scope(
                    state: \.home,
                    action: \.home
                )
            )
        }
    }
}

struct SidebarView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        List(selection: $store.selectedTab) {
            Label("Home", systemImage: "house.fill")
                .tag(AppTab.home)
            Label("Settings", systemImage: "gear.fill")
                .tag(AppTab.settings)
        }
        .listStyle(.sidebar)
        .padding()
    }
}
