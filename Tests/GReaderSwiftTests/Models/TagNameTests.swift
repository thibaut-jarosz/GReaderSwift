@testable import GReaderSwift
import Nimble
import XCTest

final class TagNameTests: XCTestCase {
    
    func test_Name_ShouldReturnSameValueAsTagIDName() {
        // Given
        let tag = Tag(id: "user/-/label/Some Name", type: nil)
        expect(tag.id.name) == "Some Name"
        
        // When
        let result = tag.name
        
        // Then
        expect(result) == tag.id.name
    }
    
    func test_Name_ShouldReturnNil_WhenTagIDNameAlsoReturnsNil() {
        // Given
        let tag = Tag(id: "user/-/state/com.google/starred", type: nil)
        expect(tag.id.name).to(beNil())
        
        // When
        let result = tag.name
        
        // Then
        expect(result).to(beNil())
    }
    
}
