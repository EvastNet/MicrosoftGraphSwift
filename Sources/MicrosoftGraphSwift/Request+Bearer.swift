//  Request+Bearer.swift
//

import Vapor
import Foundation

extension Request{
    
    public func addBearerToken(_ config: MicrosoftGraphConfig) throws{
        let cache = config.cache
        let client = config.client
        if let apiToken = try cache.get("graphToken")?.string{
            self.headers["Authorization"] = "Bearer " + apiToken
        }else{
            
            var b = JSON()
            try b.set("client_id", config.clientId)
            try b.set("client_secret", config.clientSecret)
            try b.set("grant_type", config.grantType.rawValue)
            
            let tokenUrl = MicrosoftGraph.instance + "/" + config.tenantId + "/oauth2/token"
            try b.set("resource", MicrosoftGraph.resource)
            
            let request = Request(method: .post, uri: tokenUrl, body: b.makeBody())
            request.formURLEncoded = b.makeNode(in: nil)
            let response = try client.respond(to: request)
            guard let token = response.data["access_token"]?.string else{
                throw MicrosoftGraphError.init(.internalServerError, reason: "No access token with server response")
            }
            
            guard let expiration = response.data["expires_in"]?.int else{
                throw MicrosoftGraphError.init(.internalServerError, reason: "No expiration date with server response")
            }
            
            try cache.set("graphToken", token.makeNode(in: nil), expiration: Date(timeIntervalSinceNow: TimeInterval(expiration)))
            self.headers["Authorization"] = "Bearer " + token
        }
    }
}
