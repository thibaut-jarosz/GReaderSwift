import XCTest
import Nimble

final class StringTests: XCTestCase {
    func test_URLQueryItems_ShouldReturnQueryItems_WhenStringIsCorrectlyFormatted() {
        // Given
        let string = "a=b&c=d"
        
        // When
        let result = string.urlQueryItems
        
        // Then
        expect(result.count) == 2
        expect(result).to(contain([
            .init(name: "a", value: "b"),
            .init(name: "c", value: "d"),
        ]))
    }
    
    func test_URLQueryItems_ShouldReturnAnEmptyArray_WhenStringIsEmpty() {
        // Given
        let string = ""
        
        // When
        let result = string.urlQueryItems
        
        // Then
        expect(result).to(beEmpty())
    }
    
    func test_URLQueryItems_ShouldReturnAQueryItemWithFullBaseURLAsName_WhenStringIsAURL() {
        // Given
        let string = "http://localhost/test?a=b&c=d"
        
        // When
        let result = string.urlQueryItems
        
        // Then
        expect(result) == [
            .init(name: "http://localhost/test?a", value: "b"),
            .init(name: "c", value: "d"),
        ]
    }
    
    func test_URLQueryItems_ShouldReturnQueryItemsWithNilValues_WhenEqualSignIsMissing() {
        // Given
        let string = "a&b=c&d"
        
        // When
        let result = string.urlQueryItems
        
        // Then
        expect(result) == [
            .init(name: "a", value: nil),
            .init(name: "b", value: "c"),
            .init(name: "d", value: nil),
        ]
    }
    
    func test_URLQueryItems_ShouldReturnQueryItemsWithEmptyValues_WhenEqualSignIsDirectlyFollowedByAnAmpersand() {
        // Given
        let string = "a=&b=c&d="

        // When
        let result = string.urlQueryItems
        
        // Then
        expect(result) == [
            .init(name: "a", value: ""),
            .init(name: "b", value: "c"),
            .init(name: "d", value: ""),
        ]
    }
}
