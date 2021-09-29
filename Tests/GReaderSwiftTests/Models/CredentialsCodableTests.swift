@testable import GReaderSwift
import Nimble
import XCTest

final class CredentialsCodableTests: XCTestCase {
    func test_Encode_ShouldNotEncodeCachedToken() throws {
        // Given
        let credentials = Credentials(
            baseURL: URL(string: "https://localhost/api/")!,
            username: "some_username",
            authKey: "some_key"
        )
        credentials.cachedTokenTestAccess = "some_token"
        
        // When
        let json = try JSONEncoder().encode(credentials)
        let jsonString = String(data: json, encoding: .utf8)
        
        // Then
        expect(jsonString).notTo(contain("cachedToken"))
        expect(jsonString).notTo(contain("some_token"))
    }
    
    func test_Decode_ShouldNotDecodeCachedToken() throws {
        // Given
        let jsonString = """
        {
            "baseURL": "https://localhost/api/",
            "username": "some_username",
            "authKey": "some_key",
            "cachedToken": "some_token",
        }
        """
        
        // When
        let credentials = try JSONDecoder().decode(
            Credentials.self,
            from: jsonString.data(using: .utf8)!
        )
        
        // Then
        expect(credentials.baseURL) == URL(string: "https://localhost/api/")!
        expect(credentials.username) == "some_username"
        expect(credentials.authKey) == "some_key"
        expect(credentials.cachedTokenTestAccess).to(beNil())
    }
}
