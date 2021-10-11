@testable import GReaderSwift
import Mocker
import Nimble
import XCTest

final class TagRenameTests: XCTestCase {
    
    let baseURL = URL(string: "https://localhost/api/")!

    /// Helper function to create a mock
    /// - Parameter statusCode: response status code
    /// - Returns: The created mock
    private func mock(statusCode: Int = 200) -> Mock {
        let url = URL(string: "reader/api/0/rename-tag", relativeTo: baseURL)!
        return Mock(url: url, dataType: .json, statusCode: statusCode, data: [
            .post : "ignored response".data(using: .utf8)!,
        ])
    }
    
    /// Helper function to create a mock for token request
    /// - Parameters:
    ///   - statusCode: response status code
    ///   - response: response data
    /// - Returns: The created mock
    private func tokenMock(statusCode: Int = 200, response: Data) -> Mock {
        let url = URL(string: URLPath.token.rawValue, relativeTo: baseURL)!
        return Mock(url: url, dataType: .json, statusCode: statusCode, data: [
            .get : response,
        ])
    }
    
    func test_Rename_ShouldReturnRenamedTagID_WhenEverythingSucceeded() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        mock().register()
        tokenMock(response: "some_token".data(using: .utf8)!).register()
        let tag = Tag(id: "user/-/label/Old name", type: nil)
        
        // When
        let result = try await tag.rename(to: "New Name", using: credentials)
        
        // Then
        expect(result) == Tag.ID("user/-/label/New Name")
    }
    
    func test_Rename_ShouldSendValidHeadersAndPostData() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let tag = Tag(id: "user/-/label/Old name", type: nil)
        tokenMock(response: "some_token".data(using: .utf8)!).register()
        var mock = mock()
        
        mock.onRequest = { request, _ in
            // Then
            expect(request.url) == URL(string: "https://localhost/api/reader/api/0/rename-tag")!
            expect(request.httpMethod) == "POST"
            expect(request).to(beAuthorized(withAuthKey: "auth_key"))
            expect(request).to(haveURLEncodedForm([
                .init(name: "output", value: "json"),
                .init(name: "T", value: "some_token"),
                .init(name: "s", value: "user/-/label/Old name"),
                .init(name: "dest", value: "user/-/label/New Name")
            ]))
        }
        mock.register()

        // When
        try await tag.rename(to: "New Name", using: credentials)
    }
    
    func test_Rename_ShouldThrowCannotRenameTagError_WhenTagDoesNotMeetTheRequirementsToBeRenamed() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        let tag = Tag(id: "abc/def", type: nil)
        
        // When
        do {
            let _ = try await tag.rename(to: "New Name", using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .cannotRenameTag
        }
    }
    
    func test_Rename_ShouldThrowAServerResponseError_WhenThereIsAServerError() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        mock(statusCode: 500).register()
        tokenMock(response: "some_token".data(using: .utf8)!).register()
        let tag = Tag(id: "user/-/label/Old name", type: nil)
        
        // When
        do {
            let _ = try await tag.rename(to: "New Name", using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .serverResponseError(500)
        }
    }
    
    func test_Rename_ShouldThrowAServerResponseError_WhenThereIsAServerErrorWithTokenRequest() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        mock().register()
        tokenMock(statusCode: 500, response: Data()).register()
        let tag = Tag(id: "user/-/label/Old name", type: nil)
        
        // When
        do {
            let _ = try await tag.rename(to: "New Name", using: credentials)
            XCTFail("Error should have been thrown")
        }
        catch {
            // Then
            expect(error as? GReaderError) == .serverResponseError(500)
        }
    }
    
    func test_Rename_ShouldNotThrowAServerResponseError_WhenThereIsAServerErrorWithTokenRequestAndTokenIsAlreadyCached() async throws {
        // Given
        let credentials = Credentials(baseURL: baseURL, username: "username", authKey: "auth_key")
        credentials.cachedTokenTestAccess = "some_token"
        mock().register()
        tokenMock(statusCode: 500, response: Data()).register()
        let tag = Tag(id: "user/-/label/Old name", type: nil)
        
        // When
        let result = try await tag.rename(to: "New Name", using: credentials)
        
        // Then
        expect(result) == Tag.ID("user/-/label/New Name")
    }
}
