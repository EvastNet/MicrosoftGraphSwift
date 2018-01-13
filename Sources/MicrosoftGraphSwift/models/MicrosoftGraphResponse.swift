import Foundation

// All response types are wrapped in an object like this.
struct MicrosoftGraphResponse<T: Codable>: Codable {
    let value: T?
}



