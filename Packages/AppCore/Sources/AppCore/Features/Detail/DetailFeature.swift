import ComposableArchitecture
import Foundation

@Reducer
public struct DetailFeature {
    @ObservableState
    public struct State: Equatable, Hashable {
        public var id: UUID
        public var item: Item
        public var detailText: String?
        public var isLoading = false

        public init(id: UUID = UUID(), item: Item) {
            self.id = id
            self.item = item
        }
    }

    public enum Action {
        case task
        case loadDetail
        case loadDetailResponse(Result<String, Error>)
    }

    @Dependency(\.itemService) var itemService

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .task:
                return .run { send in
                    await send(.loadDetail)
                }

            case .loadDetail:
                state.isLoading = true
                return .run { [itemId = state.item.id] send in
                    do {
                        let detail = try await itemService.fetchDetail(for: itemId)
                        await send(.loadDetailResponse(.success(detail)))
                    } catch {
                        await send(.loadDetailResponse(.failure(error)))
                    }
                }

            case .loadDetailResponse(.success(let text)):
                state.detailText = text
                state.isLoading = false
                return .none

            case .loadDetailResponse(.failure):
                state.isLoading = false
                return .none
            }
        }
    }
}
