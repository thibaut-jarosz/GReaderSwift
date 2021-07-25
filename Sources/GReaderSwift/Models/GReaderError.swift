import Foundation

enum GReaderError: Error, Equatable {
    case serverResponseError(_ statusCode: Int)
    case invalidDataResponse
}
