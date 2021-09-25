@testable import GReaderSwift
import Nimble
import XCTest

final class CredentialsCodableTests: XCTestCase {
    func test_Encode_ShouldNotEncodePrivateToken() throws {
        // Given
        let credentials = Credentials(
            baseURL: URL(string: "https://localhost/api/")!,
            username: "some_username",
            authKey: "some_key"
        )
        credentials.privateToken = "some_token"
        
        // When
        let json = try JSONEncoder().encode(credentials)
        let jsonString = String(data: json, encoding: .utf8)
        
        // Then
        expect(jsonString).notTo(contain("privateToken"))
        expect(jsonString).notTo(contain("some_token"))
    }
    
    func test_Decode_ShouldNotDecodePrivateToken() throws {
        // Given
        let jsonString = """
        {
            "baseURL": "https://localhost/api/",
            "username": "some_username",
            "authKey": "some_key",
            "privateToken": "some_token",
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
        expect(credentials.privateToken).to(beNil())
    }
}
