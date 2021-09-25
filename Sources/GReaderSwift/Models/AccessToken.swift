import Foundation

/// Token used to perform actions that change data (create, update, delete…).
public struct AccessToken: RawRepresentable {
    public var rawValue: String
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}
