import Foundation

// All response types are wrapped in an object like this.
struct MicrosoftGraphResponse<T: Codable>: Codable {
    let nextLink: String?
    let value: T?
    
    public enum CodingKeys: String, CodingKey {
        case nextLink = "@odata.nextLink"
        case value
    }
}



