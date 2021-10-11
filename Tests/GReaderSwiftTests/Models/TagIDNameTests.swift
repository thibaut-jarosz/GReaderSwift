@testable import GReaderSwift
import Nimble
import XCTest

final class TagIDNameTests: XCTestCase {
    
    func test_Name_ShouldReturnValueAfterLabelInID() {
        // Given
        let tagID = Tag.ID("user/-/label/Some Name")
        
        // When
        let result = tagID.name
        
        // Then
        expect(result) == "Some Name"
    }
    
    func test_Name_ShouldReturnNil_WhenLabelCannotBeFoundInID() {
        // Given
        let tagID = Tag.ID("user/-/state/com.google/starred")
        
        // When
        let result = tagID.name
        
        // Then
        expect(result).to(beNil())
    }
    
    func test_Name_ReturnValueAfterLabelInID_WhenTypeIsNil() {
        // Given
        let tagID = Tag.ID("user/-/label/Some Name")
        
        // When
        let result = tagID.name
        
        // Then
        expect(result) == "Some Name"
    }
    
    // MARK: - Renamed
    
    func test_Renamed_ShouldUdpateTagID_WhenTagIDContainsALabel() throws {
        // Given
        let tagID = Tag.ID("user/-/label/Some Name")
        let newName = "Another Name"
        
        // When
        let result = tagID.renamed(newName)
        
        // Then
        expect(result) == "user/-/label/Another Name"
        expect(result?.name) == newName
    }
    
    func test_Renamed_ShouldReturnNil_WhenLabelCannotBeFoundInID() {
        // Given
        let tagID = Tag.ID("user/-/state/com.google/starred")

        // When
        let result = tagID.renamed("abc")
        
        // Then
        expect(result).to(beNil())
    }
    
}
