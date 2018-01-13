import Foundation

//Main Group object
open class Group: Codable{
    public let id: String
    public let description: String?
    public let displayName: String?
    public var odataType: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case displayName
        case odataType = "@odata.type"
    }
    
    public init(
        id: String,
        description: String? = nil,
        displayName: String? = nil,
        odataType: String? = nil
        ){
        self.id = id
        self.description = description
        self.displayName = displayName
        self.odataType = odataType
        
    }
}





