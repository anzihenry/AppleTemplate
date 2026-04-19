import ComposableArchitecture
import Foundation

public enum AppTab: String, CaseIterable, Identifiable {
    case home
    case settings

    public var id: Self { self }
}

@Reducer
public struct AppFeature {
    @ObservableState
    public struct State: Equatable {
        public var home = HomeFeature.State()
        public var settings = SettingsFeature.State()
        public var selectedTab: AppTab = .home

        public init() {}
    }

    public enum Action {
        case home(HomeFeature.Action)
        case settings(SettingsFeature.Action)
        case selectedTab(AppTab)
    }

    @Dependency(\.continuousClock) var clock

    public var body: some Reducer<State, Action> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Scope(state: \.settings, action: \.settings) {
            SettingsFeature()
        }
        Reduce { state, action in
            switch action {
            case .selectedTab(let tab):
                state.selectedTab = tab
                return .none
            case .home, .settings:
                return .none
            }
        }
    }
}
