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

//Member object for returning members
public struct GroupMember: Codable{
    public let id: String?
    public let displayName: String?
    public let odataType: String?
    public let odataId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case odataType = "@odata.type"
        case odataId = "@odata.id"
    }
    
    public init(
        id: String?,
        displayName: String? = nil,
        odataType: String? = nil,
        odataId: String? = nil
        ){
        self.id = id
        self.displayName = displayName
        self.odataType = odataType
        self.odataId = odataId
    }
    
    public init(odataId: String?){
        self.odataId = odataId
        self.id = nil
        self.displayName = nil
        self.odataType = nil
    }
}



