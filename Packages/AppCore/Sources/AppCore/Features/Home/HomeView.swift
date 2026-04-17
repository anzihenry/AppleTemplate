import SwiftUI
import ComposableArchitecture

public struct HomeView: View {
    let store: StoreOf<HomeFeature>

    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: store.scope(state: \.path, action: \.path)) {
            List {
                ForEach(store.items) { item in
                    Button {
                        store.send(.itemTapped(item))
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                Text(item.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(String(localized: "Home"))
            .refreshable {
                store.send(.refresh, animation: .default)
            }
            .navigationDestination(
                store: store.scope(state: \.path, action: \.path)
            ) { store in
                DetailView(store: store)
            }
        }
        .task {
            await store.send(.task).finish()
        }
        .overlay {
            if store.isLoading {
                ProgressView()
            }
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { store.errorMessage != nil },
                set: { _ in }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(store.errorMessage ?? "")
        }
    }
}
