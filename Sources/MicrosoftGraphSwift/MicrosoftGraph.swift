import Foundation
import Vapor
import Cache

public class MicrosoftGraph{
    
    public static let instance = "https://login.microsoftonline.com"
    public static let resource = "https://graph.microsoft.com/"
    public static let scope = "https://graph.microsoft.com/.default"
    
    public let config: MicrosoftGraphConfig
    
    //Processors
    public let groups: GroupsProcessor
    public let users: UsersProcessor
    
    /// Initializes a instance of a Microsoft Graph API wrapper class
    ///
    /// - Parameters:
    ///   - grantType: the Oauth 2.0 Authentication grant type
    ///   - clientId: application id as found in azure portal
    ///   - clientSecret: application secret from azure portal
    ///   - tenantId: identifier for tenant for which the graph api is being accessed
    public init(
        grantType: OAuthGrant,
        clientId: String,
        clientSecret: String,
        tenantId: String,
        client: ClientFactoryProtocol,
        cache: CacheProtocol
        ){
        
        let c = MicrosoftGraphConfig(
            grantType: grantType,
            clientId: clientId,
            clientSecret: clientSecret,
            tenantId: tenantId,
            client: client,
            cache: cache,
            instance: MicrosoftGraph.resource + "v1.0/" + tenantId + "/")
        
        self.config = c
        
        //Processors
        self.groups = GroupsProcessor(c)
        self.users = UsersProcessor(c)
    }
}

/// Configuration struct containing all configurable values for passing around
public struct MicrosoftGraphConfig {
    let grantType: OAuthGrant
    let clientId: String
    let clientSecret: String
    let tenantId: String
    let client: ClientFactoryProtocol
    let cache: CacheProtocol
    let instance: String
}





















