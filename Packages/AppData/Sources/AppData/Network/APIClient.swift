import Dependencies
import Foundation

public struct APIClient: TestDependencyKey {
    public var request: @Sendable (Endpoint) async throws -> Data

    public init(request: @escaping @Sendable (Endpoint) async throws -> Data) {
        self.request = request
    }

    public static let liveValue = APIClient(
        request: { endpoint in
            var urlRequest = URLRequest(url: endpoint.url)
            urlRequest.httpMethod = endpoint.method.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = endpoint.body

            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }

            return data
        }
    )

    public static let testValue = APIClient(
        request: unimplemented("APIClient.request")
    )
}

public enum APIError: Error {
    case invalidResponse
    case decodingFailed
    case networkError(String)
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public struct Endpoint {
    public let url: URL
    public let method: HTTPMethod
    public let body: Data?

    public init(url: URL, method: HTTPMethod = .get, body: Data? = nil) {
        self.url = url
        self.method = method
        self.body = body
    }
}

extension DependencyValues {
    public var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
