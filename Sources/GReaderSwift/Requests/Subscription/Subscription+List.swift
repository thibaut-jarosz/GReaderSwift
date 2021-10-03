import Foundation

public extension Subscription {
    private struct SubscriptionContainer: Codable {
        let subscriptions: [Subscription]
    }
    
    /// Retrieve a list of all Subscriptions on the server described in given credentials
    /// - Parameter credentials: Credentials used to connect to the server
    /// - Returns: A list of all Subscriptions.
    static func list(using credentials: Credentials) async throws -> [Subscription] {
        try await URLRequest(
            credentials: credentials,
            path: .subscriptionList,
            queryItems: [.jsonOutput]
        )
        .send(withJSONResponse: SubscriptionContainer.self)
        .subscriptions
    }
}
