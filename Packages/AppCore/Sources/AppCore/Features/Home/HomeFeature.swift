import ComposableArchitecture
import Foundation

@Reducer
public struct HomeFeature {
    @ObservableState
    public struct State: Equatable {
        public var items: [Item] = []
        public var isLoading = false
        public var errorMessage: String?

        public init() {}
    }

    public enum Action {
        case task
        case loadItems
        case loadItemsResponse(Result<[Item], Error>)
        case itemTapped(Item)
        case refresh
    }

    @Dependency(\.itemService) var itemService

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .task:
                return .run { send in
                    await send(.loadItems)
                }

            case .loadItems:
                state.isLoading = true
                state.errorMessage = nil
                return .run { send in
                    do {
                        let items = try await itemService.fetchItems()
                        await send(.loadItemsResponse(.success(items)))
                    } catch {
                        await send(.loadItemsResponse(.failure(error)))
                    }
                }

            case .loadItemsResponse(.success(let items)):
                state.items = items
                state.isLoading = false
                return .none

            case .loadItemsResponse(.failure(let error)):
                state.errorMessage = error.localizedDescription
                state.isLoading = false
                return .none

            case .itemTapped:
                return .none

            case .refresh:
                return .run { send in
                    await send(.loadItems)
                }
            }
        }
    }
}
