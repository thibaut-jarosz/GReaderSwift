@testable import GReaderSwift
import Nimble
import XCTest

/// Protocol used to remove deprecated warning from using `Credentials.cachedToken`
fileprivate protocol CredentialsCachedToken: AnyObject {
    var cachedToken: String? { get set }
}
extension Credentials: CredentialsCachedToken {}

class CredentialsTestsHelperTests: XCTestCase {
    func test_CachedTokenTestAccess_ShouldSetValueOfCachedToken() {
        // Given
        let credentials = Credentials(
            baseURL: URL(string: "https://localhost/api/")!,
            username: "some_username",
            authKey: "some_key"
        )
        (credentials as CredentialsCachedToken).cachedToken = "old_token"
        
        // When
        credentials.cachedTokenTestAccess = "new_token"
        
        // Then
        expect((credentials as CredentialsCachedToken).cachedToken) == "new_token"
    }
    
    func test_CachedTokenTestAccess_ShouldReturnValueOfCachedToken() {
        // Given
        let credentials = Credentials(
            baseURL: URL(string: "https://localhost/api/")!,
            username: "some_username",
            authKey: "some_key"
        )
        (credentials as CredentialsCachedToken).cachedToken = "some_token"
        
        // When
        let result = credentials.cachedTokenTestAccess
        
        // Then
        expect(result) == "some_token"
    }
}
