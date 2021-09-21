import XCTest
@testable import GReaderSwift
import Mocker
import Nimble

final class AccessTokenTests: XCTestCase {
    let baseURL = URL(string: "https://localhost/api/")!
    
    /// Helper function to create a mock
    /// - Parameters:
    ///   - statusCode: response status code
    ///   - response: response data
    /// - Returns: The created mock
    private func mock(statusCode: Int = 200, response: Data) -> Mock {
        let url = URL(string: "reader/api/0/token", relativeTo: baseURL)!
        return Mock(url: url, dataType: .json, statusCode: statusCode, data: [
            .get : response,
        ])
    }
    
    func test_Init_ShouldCreateValidToken_WhenServerRespondsWithValidData() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mockedResponse = "some_token"
        let mock = mock(response: mockedResponse.data(using: .utf8)!)
        mock.register()
        
        // When
        let result = try await AccessToken(credentials: credentials)
        
        // Then
        expect(result.rawValue) == "some_token"
    }
    
    func test_Init_ShouldUseFirstNonEmptyStringAsToken_WhenServerRespondsWithMultipleStringsOnMultipleLines() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mockedResponse = """
            
            some token
            
            another_token
            
            """
        let mock = mock(response: mockedResponse.data(using: .utf8)!)
        mock.register()
        
        // When
        let result = try await AccessToken(credentials: credentials)
        
        // Then
        expect(result.rawValue) == "some token"
    }
    
    func test_Init_ShouldSendValidAuthorizationHeaderInRequest() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mockedResponse = "some_token"
        var mock = mock(response: mockedResponse.data(using: .utf8)!)
        
        mock.onRequest = { request, _ in
            // Then
            expect(request.url) == URL(string: "https://localhost/api/reader/api/0/token")!
            expect(request).to(beAuthorized(withAuthKey: "auth_key"))
        }
        mock.register()
        
        // When
        let _ = try await AccessToken(credentials: credentials)
    }
    
    func test_Init_ShouldThrowAServerResponseError_WhenThereIsAServerError() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mockedResponse = "some_token"
        
        // When
        let mock = mock( statusCode: 500, response: mockedResponse.data(using: .utf8)!)
        mock.register()
        
        do {
            let _ = try await AccessToken(credentials: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .serverResponseError(500)
        }
    }
    
    func test_Init_ShouldThrowAnInvalidDataResponseError_WhenResponseOnlyContainsEmptyStrings() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mockedResponse = """
            
            
            """.data(using: .utf8)!
        
        // When
        let mock = mock(response: mockedResponse)
        mock.register()
        
        do {
            let _ = try await AccessToken(credentials: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .invalidDataResponse(mockedResponse)
        }
    }
    
    func test_Init_ShouldThrowAnInvalidDataResponseError_WhenResponseIsEmpty() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mockedResponse = "".data(using: .utf8)!
        
        // When
        let mock = mock(response: mockedResponse)
        mock.register()
        
        do {
            let _ = try await AccessToken(credentials: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .invalidDataResponse(mockedResponse)
        }
    }
    
}
