import SwiftUI
import ComposableArchitecture

public struct SettingsView: View {
    @Bindable public var store: StoreOf<SettingsFeature>

    public init(store: StoreOf<SettingsFeature>) {
        self.store = store
    }

    public var body: some View {
        Form {
            Section("Account") {
                TextField("Username", text: $store.username)
            }

            Section("Appearance") {
                Toggle("Dark Mode", isOn: $store.darkModeEnabled)
                VStack(alignment: .leading) {
                    Text("Font Size: \(Int(store.fontSize))")
                    Slider(value: $store.fontSize, in: 12...24, step: 1)
                }
            }

            Section("Notifications") {
                Toggle("Enable Notifications", isOn: $store.notificationsEnabled)
            }

            Section {
                Button("Save Settings") {
                    store.send(.saveSettings, animation: .default)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle(String(localized: "Settings"))
    }
}
