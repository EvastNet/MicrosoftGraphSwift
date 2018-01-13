import Foundation
import Vapor
import HTTP

/// Processor for "/groups" endpoint
public struct GroupsProcessor: MicrosoftGraphProcessor{
    
    var baseUrl: String = "groups"
    let config: MicrosoftGraphConfig
    let client: ClientFactoryProtocol
    let defaultQuery: [String: Node]
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    
    init(_ config: MicrosoftGraphConfig) {
        self.config = config
        self.client = config.client
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        self.defaultQuery = [:]
    }
    
    ///Create a group in Azure AD
    public func create(){}
    
    ///Fetch a single group from Azure AD
    public func get(id: String, select: [String]? = nil) throws -> Group{
        var params: [String: String] = [:]
        if let s = select{
            params["$select"] = makeSelectQuery(s)
        }
        
        return try makeRequest([id], query: params)
    }
    
    ///Fetch a list of groups from Azure AD
    public func list(select: [String]? = nil) throws -> [Group] {
        var params: [String: String] = [:]
        if let s = select{
            params["$select"] = makeSelectQuery(s)
        }
        return try makeRequest(query: params)
    }
    
    
    //TODO: complete implementation
    
    ///Update a group
    public func update(){}
    ///Delete a group
    public func delete(){}
    ///Add an owner to a group
    public func addOwner(){}
    ///List owners of a group
    public func listOwners(){}
    ///Remove and owner from group
    public func removeOwner(){}
    
    ///Add a member to a group
    public func addMember(group: String, member: GroupMember) throws {
        _ = try makeRequest([group, "members/$ref"], method: .post, model: member)
        
    }
    
    ///List all members of a group
    public func listMembers(id: String, select: [String]? = nil) throws -> [GroupMember] {
        var params: [String: String] = [:]
        if let s = select{
            params["$select"] = makeSelectQuery(s)
        }
        
        return try makeRequest([id, "members"], query: params)
    }
    
    ///Remove a member from a group
    public func removeMember(){}
    ///Check for membership in the specified list of groups.
    ///Returns from the list those groups of which the specified group has a direct or transitive membership.
    public func checkMemberGroups(){}
    ///Return all the groups that the specified group is a member of.
    public func getMemberGroups(){}
    ///Return all of the groups that this group is a member of.
    public func getMemberObjects(){}
}

