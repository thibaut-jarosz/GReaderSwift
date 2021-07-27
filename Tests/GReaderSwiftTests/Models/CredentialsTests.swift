import XCTest
@testable import GReaderSwift
import Mocker
import Nimble

final class CredentialsTests: XCTestCase {
    let baseURL = URL(string: "https://localhost/api/")!
    
    /// Helper function to create a mock
    /// - Parameters:
    ///   - statusCode: response status code
    ///   - response: response data
    /// - Returns: The created mock
    private func mock(statusCode: Int = 200, response: Data) -> Mock {
        let url = URL(string: "accounts/ClientLogin", relativeTo: baseURL)!
        return Mock(url: url, dataType: .json, statusCode: statusCode, data: [
            .post : response,
        ])
    }
    
    func test_Init_ShouldCreateValidCredentials_WhenServerRespondsWithValidData() async throws {
        // Given
        let mockedResponse = """
            SID=abc
            Auth=def, xyz
            LSID=ghi
            """
        let mock = mock(response: mockedResponse.data(using: .utf8)!)
        mock.register()
        
        // When
        let result = try await Credentials(on: baseURL, username: "username", password: "password")
        
        // Then
        expect(result.baseURL.absoluteString) == "https://localhost/api/"
        expect(result.username) == "username"
        expect(result.authKey) == "def, xyz"
    }
    
    func test_Init_ShouldSendValidDataInRequest() async throws {
        // Given
        let mockedResponse = "Auth=abc"
        var mock = mock(response: mockedResponse.data(using: .utf8)!)
        
        mock.onRequest = { request, _ in
            // Then
            expect(request.url) == URL(string: "https://localhost/api/accounts/ClientLogin")!
            expect(request.httpBodyStreamString?.urlQueryItems).to(contain([
                URLQueryItem(name: "Email", value: "username"),
                URLQueryItem(name: "Passwd", value: "password"),
            ]))
        }
        mock.register()
        
        // When
        let _ = try await Credentials(
            on: URL(string: "https://localhost/api/")!,
            username: "username",
            password: "password"
        )
    }
    
    func test_Init_ShouldThrowAServerResponseError_WhenThereIsAServerError() async throws {
        // Given
        let mockedResponse = "Auth=abc"
        
        // When
        let mock = mock( statusCode: 500, response: mockedResponse.data(using: .utf8)!)
        mock.register()
        
        do {
            let _ = try await Credentials(
                on: URL(string: "https://localhost/api/")!,
                username: "username",
                password: "password"
            )
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .serverResponseError(500)
        }
    }
    
    func test_Init_ShouldThrowAnInvalidDataResponseError_AuthIsMissing() async throws {
        // Given
        let mockedResponse = "Authentication=abc"
        
        // When
        let mock = mock(response: mockedResponse.data(using: .utf8)!)
        mock.register()
        
        do {
            let _ = try await Credentials(
                on: URL(string: "https://localhost/api/")!,
                username: "username",
                password: "password"
            )
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .invalidDataResponse
        }
    }
    
    func test_Init_ShouldThrowAnInvalidDataResponseError_AuthIsEmpty() async throws {
        // Given
        let mockedResponse = "Auth="
        
        // When
        let mock = mock(response: mockedResponse.data(using: .utf8)!)
        mock.register()
        
        do {
            let _ = try await Credentials(
                on: URL(string: "https://localhost/api/")!,
                username: "username",
                password: "password"
            )
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .invalidDataResponse
        }
    }
    
}
