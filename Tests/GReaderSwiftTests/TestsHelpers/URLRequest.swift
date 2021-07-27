import Foundation

extension URLRequest {
    /// The `httpBodyStream` converted to `String`
    var httpBodyStreamString: String? {
        guard let body = httpBodyStreamData else { return nil }
        return String(data: body, encoding: .utf8)
    }
    
    /// In `URLProtocol`, the `body` property of a `Request` is `nil`.
    /// The only way to retrieve the `body` is to convert `httpBodyStream` stream to `Data`.
    ///
    /// The content is a copy to the `httpBodyStreamData()` private function in `Mocker` package.
    private var httpBodyStreamData: Data? {
        guard let bodyStream = self.httpBodyStream else { return nil }
        
        bodyStream.open()
        
        // Will read 16 chars per iteration. Can use bigger buffer if needed
        let bufferSize: Int = 16
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        var data = Data()
        
        while bodyStream.hasBytesAvailable {
            let readData = bodyStream.read(buffer, maxLength: bufferSize)
            data.append(buffer, count: readData)
        }
        
        buffer.deallocate()
        bodyStream.close()
        
        return data
    }
}
