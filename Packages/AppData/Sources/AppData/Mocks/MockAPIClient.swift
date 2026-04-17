import Foundation

public enum MockAPIClient {
    public static let success = APIClient(
        request: { endpoint in
            let mockResponse: [String: Any] = [
                "status": "success",
                "data": [],
            ]
            return try JSONSerialization.data(withJSONObject: mockResponse)
        }
    )

    public static let failure = APIClient(
        request: { _ in
            throw APIError.invalidResponse
        }
    )
}
