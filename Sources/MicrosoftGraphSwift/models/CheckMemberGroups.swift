//
//  CheckMemberGroups.swift
//  MicrosoftGraphSwift
//
//  Created by Aleks Vlahovic on 1/13/18.
//

import Foundation


public struct CheckMemberGroups: Codable {
    public let groupIds: [String]?
    public let value: [String]?

    enum CodingKeys: String, CodingKey {
        case groupIds
        case value
    }
    
    public init(
        groupIds: [String]? = nil,
        value: [String]? = nil
        ){
        self.groupIds = groupIds
        self.value = value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(groupIds, forKey: .groupIds)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decodeIfPresent(Array<String>.self, forKey: .value)
        groupIds = try container.decodeIfPresent(Array<String>.self, forKey: .groupIds)
    }
    
}
