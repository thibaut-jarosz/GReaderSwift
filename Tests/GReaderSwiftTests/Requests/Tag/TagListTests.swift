@testable import GReaderSwift
import Mocker
import Nimble
import XCTest

final class TagListTests: XCTestCase {
    
    let baseURL = URL(string: "https://localhost/api/")!
    let mockedResponse = """
        {
            "tags": [
                { "id": "abc/def" },
                { "id": "123/456", "type": "folder" }
            ]
        }
        """
    
    /// Helper function to create a mock
    /// - Parameters:
    ///   - statusCode: response status code
    ///   - response: response data
    /// - Returns: The created mock
    private func mock(statusCode: Int = 200, response: Data) -> Mock {
        let url = URL(string: "reader/api/0/tag/list?output=json", relativeTo: baseURL)!
        return Mock(url: url, dataType: .json, statusCode: statusCode, data: [
            .get : response,
        ])
    }
    
    func test_List_ShouldReturnTagList_WhenServerRespondsWithValidData() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mock = mock(response: mockedResponse.data(using: .utf8)!)
        mock.register()
        
        // When
        let result = try await Tag.list(using: credentials)
        
        // Then
        expect(result) == [
            Tag(id: "abc/def", type: nil),
            Tag(id: "123/456", type: "folder")
        ]
    }
    
    func test_List_ShouldSendValidAuthorizationHeaderInRequest() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        var mock = mock(response: mockedResponse.data(using: .utf8)!)
        
        mock.onRequest = { request, _ in
            // Then
            expect(request.url) == URL(string: "https://localhost/api/reader/api/0/tag/list?output=json")!
            expect(request).to(beAuthorized(withAuthKey: "auth_key"))
        }
        mock.register()
        
        // When
        let _ = try await Tag.list(using: credentials)
    }
    
    func test_Init_ShouldThrowAServerResponseError_WhenThereIsAServerError() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        
        // When
        let mock = mock( statusCode: 500, response: mockedResponse.data(using: .utf8)!)
        mock.register()

        do {
            let _ = try await Tag.list(using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .serverResponseError(500)
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
            let _ = try await Tag.list(using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .invalidDataResponse(mockedResponse)
        }
    }
    
    func test_Init_ShouldThrowAnInvalidDataResponseError_WhenResponseIsNotValidJSON() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mockedResponse = """
        {
            "tags": [
                { "id": "abc/def" },
                { "id": "123/456", "type": "folder" }
            ]
        
        """.data(using: .utf8)!
        
        // When
        let mock = mock(response: mockedResponse)
        mock.register()
        
        do {
            let _ = try await Tag.list(using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .invalidDataResponse(mockedResponse)
        }
    }
    
    func test_Init_ShouldThrowAnInvalidDataResponseError_WhenResponseJSONIsMissingARequiredKey() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let mockedResponse = """
        {
            "tags": [
                { "ids": "abc/def" },
                { "id": "123/456", "type": "folder" }
            ]
        
        """.data(using: .utf8)!
        
        // When
        let mock = mock(response: mockedResponse)
        mock.register()
        
        do {
            let _ = try await Tag.list(using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .invalidDataResponse(mockedResponse)
        }
    }
    
}
