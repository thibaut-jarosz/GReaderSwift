import Foundation

internal extension Subscription {
    
    enum EditAction: String {
        case edit
        case unsubscribe
    }
    
    /// Generic request for all `subscription/edit` requests
    /// - Parameters:
    ///   - credentials: Credentials used to connect to the server
    ///   - action: Value of the `ac` action parameter
    ///   - additionalParams: Other parameters to pass to the request.
    func edit(
        using credentials: Credentials,
        action: EditAction = .edit,
        additionalParams: URLQueryItem...
    ) async throws {
        // Create request
        var request = URLRequest(
            credentials: credentials,
            path: .subscriptionEdit
        )
        await request.setURLEncodedPostForm(
            [
                try .token(from: credentials),
                .init(name: "s", value: id.rawValue),
                .init(name: "ac", value: action.rawValue)
            ] + additionalParams
        )
        
        // Send request
        try await request.send()
    }
    
}
