import SwiftUI
import ComposableArchitecture

public struct DetailView: View {
    let store: StoreOf<DetailFeature>

    public init(store: StoreOf<DetailFeature>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(store.item.title)
                    .font(.largeTitle)
                    .bold()

                Text(store.item.subtitle)
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                if store.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else if let detail = store.detailText {
                    Text(detail)
                        .font(.body)
                        .lineSpacing(4)
                } else {
                    Text("No details available")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(store.item.title)
        .task {
            await store.send(.task).finish()
        }
    }
}
