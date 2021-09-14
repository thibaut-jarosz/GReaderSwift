@testable import GReaderSwift
import Nimble
import XCTest

final class URLQueryItemTests: XCTestCase {
    
    func test_JSONOutput_ShouldReturnACorrectlyConfiguredQueryItem() {
        // Given
        
        // When
        let result = URLQueryItem.jsonOutput
        
        // Then
        expect(result) == URLQueryItem(name: "output", value: "json")
    }
    
}
