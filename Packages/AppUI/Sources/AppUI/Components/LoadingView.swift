import SwiftUI

public struct LoadingView: View {
    public var message: String?

    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: 12) {
            ProgressView()
            if let message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    LoadingView(message: "Loading...")
}
