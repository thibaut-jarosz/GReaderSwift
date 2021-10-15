import Foundation

public extension Subscription {
    
    /// Delete the current subscription from server
    /// - Parameter credentials: Credentials used to connect to the server
    func delete(using credentials: Credentials) async throws {
        try await edit(using: credentials, action: .unsubscribe)
    }
    
    /// Rename the current subscription
    /// - Parameters:
    ///   - newName: The new name of the subscription
    ///   - credentials: Credentials used to connect to the server
    func rename(to newName: String, using credentials: Credentials) async throws {
        try await edit(using: credentials, additionalParams: .init(name: "t", value: newName))
    }
    
    /// Tag the current subscription
    /// - Parameters:
    ///   - tagID: Tag ID of the tag to add to the current subscription
    ///   - credentials: Credentials used to connect to the server
    func tag(with tagID: Tag.ID, using credentials: Credentials) async throws {
        try await edit(using: credentials, additionalParams: .init(name: "a", value: tagID.rawValue))
    }
    
    /// Untag the current subscription
    /// - Parameters:
    ///   - tagID: Tag ID of the tag to remove from the current subscription
    ///   - credentials: Credentials used to connect to the server
    func untag(_ tagID: Tag.ID, using credentials: Credentials) async throws {
        try await edit(using: credentials, additionalParams: .init(name: "r", value: tagID.rawValue))
    }
    
}

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
