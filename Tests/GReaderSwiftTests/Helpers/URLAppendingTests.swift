@testable import GReaderSwift
import Nimble
import XCTest

final class URLAppendingTests: XCTestCase {
    
    func test_Appending_ShouldAddPathAndQueryItemsToURL() {
        // Given
        let url = URL(string: "https://localhost/")!
        let path = URLPath.clientLogin
        
        // When
        let result = url.appending(path: path, queryItems: [
            URLQueryItem(name: "abc", value: "def"),
            URLQueryItem(name: "123", value: "456")
        ])
        
        // Then
        expect(result) == URL(string: "https://localhost/\(URLPath.clientLogin.rawValue)?abc=def&123=456")!
    }
    
    func test_Appending_ShouldAppendQueryItemsToExistingOnes() {
        // Given
        let url = URL(string: "https://localhost/?abc=def")!
        let path = URLPath.token
        
        // When
        let result = url.appending(path: path, queryItems: [
            URLQueryItem(name: "123", value: "456")
        ])
        
        // Then
        expect(result) == URL(string: "https://localhost/\(URLPath.token.rawValue)?abc=def&123=456")!
    }
    
    func test_Appending_ShouldKeepFragment() {
        // Given
        let url = URL(string: "https://localhost/?abc=def#test")!
        let path = URLPath.clientLogin
        
        // When
        let result = url.appending(path: path, queryItems: [
            URLQueryItem(name: "123", value: "456")
        ])
        
        // Then
        expect(result) == URL(string: "https://localhost/\(URLPath.clientLogin.rawValue)?abc=def&123=456#test")!
    }
    
    func test_Appending_ShouldStillAppendPath_WhenQueryItemsIsEmpty() {
        // Given
        let url = URL(string: "https://localhost/?abc=def")!
        let path = URLPath.clientLogin
        
        // When
        let result = url.appending(path: path, queryItems: [])
        
        // Then
        expect(result) == URL(string: "https://localhost/\(URLPath.clientLogin.rawValue)?abc=def")!
    }
    
    func test_Appending_ShouldStillAppendPath_WhenQueryItemsIsNil() {
        // Given
        let url = URL(string: "https://localhost/?abc=def")!
        let path = URLPath.clientLogin
        
        // When
        let result = url.appending(path: path)
        
        // Then
        expect(result) == URL(string: "https://localhost/\(URLPath.clientLogin.rawValue)?abc=def")!
    }
    
    func test_Appending_ShouldStillAppendQueryItem_WhenPathIsNil() {
        // Given
        let url = URL(string: "https://localhost/")!
        
        // When
        let result = url.appending(path: nil, queryItems: [
            .init(name: "abc", value: "def")
        ])
        
        // Then
        expect(result) == URL(string: "https://localhost/?abc=def")!
    }
    
    func test_Appending_ShouldReturnTheSameURL_WhenBothPathAndQueryItemsAreNil() {
        // Given
        let url = URL(string: "https://localhost/?abc=def")!
        
        // When
        let result = url.appending(path: nil, queryItems: nil)
        
        // Then
        expect(result) == URL(string: "https://localhost/?abc=def")!
    }
    
    func test_Appending_ShouldAppendQueryItem_WhenAnItemOfTheSameNameAlreadyExist() {
        // Given
        let url = URL(string: "https://localhost/?abc=def")!
        
        // When
        let result = url.appending(queryItems: [
            URLQueryItem(name: "abc", value: "xyz")
        ])
        
        // Then
        expect(result) == URL(string: "https://localhost/?abc=def&abc=xyz")!
    }
    
}
