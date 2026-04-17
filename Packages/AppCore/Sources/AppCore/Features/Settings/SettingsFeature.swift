import ComposableArchitecture

@Reducer
public struct SettingsFeature {
    @ObservableState
    public struct State: Equatable {
        public var username = ""
        public var notificationsEnabled = true
        public var darkModeEnabled = false
        public var fontSize: Double = 16

        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case saveSettings
        case settingsSaved
    }

    @Dependency(\.continuousClock) var clock

    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .saveSettings:
                return .run { _ in
                    try await clock.sleep(for: .seconds(0.5))
                    await MainActor.run {}
                } catch: { _, _ in
                }

            case .settingsSaved:
                return .none
            }
        }
    }
}
