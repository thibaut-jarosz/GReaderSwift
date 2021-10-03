/// Structure is representable by String
///
/// Can be usefull to ensure type safety:
/// ```
/// struct SomeID {
///     var rawValue: String
/// }
///
/// let someID: SomeID = "some value"
/// let someOtherID: SomeID = someID
/// let someString: String = someID.rawValue
/// let someOtherSring: String = someID // Error
/// ```
public protocol StringRepresentable: ExpressibleByStringInterpolation, CustomStringConvertible, Hashable, Codable, RawRepresentable where RawValue == String {
    init(rawValue: RawValue)
}

/// Default values
public extension StringRepresentable {
    init(_ value: RawValue) { self.init(rawValue: value) }
    var description: String { return String(describing: rawValue) }
    init(stringLiteral: String) { self.init(rawValue: stringLiteral) }
}
