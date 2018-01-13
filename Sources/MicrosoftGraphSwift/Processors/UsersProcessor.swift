import Foundation
import Vapor
import HTTP

/// Processor for "/users" endpoint
///
public struct UsersProcessor: MicrosoftGraphProcessor{
    
    
    var baseUrl: String = "users"
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
    
    ///Create a user in Azure AD
    public func create(user: User) throws -> User{
        return try makeRequest(method: .post, model: user)
    }
    
    ///Fetch a single user from Azure AD
    public func get(id: String, select: [String]? = nil) throws -> User{
        var params: [String: String] = [:]
        if let s = select{
            params["$select"] = makeSelectQuery(s)
        }
        
        return try makeRequest([id], query: params)
    }
    
    ///Fetch a list of users from Azure AD
    public func list(select: [String]? = nil) throws -> [User] {
        var params: [String: String] = [:]
        if let s = select{
            params["$select"] = makeSelectQuery(s)
        }
        return try makeRequest(query: params)
    }
    
    ///Update a user
    public func update(id: String, user: User) throws -> User {
        return try makeRequest([id], method: .patch, model: user)
    }
    ///Delete a user
    public func delete(){}
    ///Get the groups and directory roles that the user is a direct member of
    public func memberOf(){}
    ///Check for membership in a list of groups
    public func checkMemberGroups(){}
    ///Return all the users that the specified user is a member of.
    public func getMemberGroups(){}
    ///Return all of the users that this user is a member of.
    public func getMemberObjects(){}
}

