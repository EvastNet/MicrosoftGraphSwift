import Foundation
import Vapor
import HTTP

protocol MicrosoftGraphProcessor {
    var baseUrl: String { get }
    var config: MicrosoftGraphConfig { get }
    var client: ClientFactoryProtocol { get }
    var defaultQuery: [String: Node] { get }
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }
    
    func makeRequest<T: Codable>(_ pathComponents: [String]?,
                                 query: [String: String],
                                 method: HTTP.Method,
                                 model: T?) throws -> T
    
    func makeResponse(_ pathComponents: [String]?,
                      query: [String: String],
                      method: HTTP.Method) throws -> Response
    
    func processObjects<T: Codable>(response: Response, method: HTTP.Method) throws -> [T]
}

extension MicrosoftGraphProcessor{
    
    /// Function for creating a Microsoft Graph API request and fetching results
    ///
    /// - Parameters:
    ///   - pathComponents: optional uri path components (ie. /root/path/to/resource == [path, to, resource])
    ///   - query: optional query parameters dictionary
    ///   - method: HTTP method (ie. get, post, patch, put, delete)
    /// - Returns: requested Microsoft Graph API resource
    /// - Throws: error while creating request or fetching results
    func makeRequest<T: Codable>(_ pathComponents: [String]? = nil,
                                 query: [String: String] = [:],
                                 method: HTTP.Method = .get,
                                 model: T? = nil) throws -> T {
        
        ///From MicrosoftGraphConfig struct. Set in MicrosoftGraph wrapper.
        ///In this case: login.microsoftonline.com + baseUrl from specific Processor class
        var endpoint = config.instance + baseUrl
        
        ///Set default date decoding strategy from custom DateTypeFormatter
        decoder.dateDecodingStrategy = .formatted(DateFormatter.graphDate)
        encoder.dateEncodingStrategy = .formatted(DateFormatter.graphDate)
        
        ///adds optional uri components to baseUri
        if let p = pathComponents{
            for component in p{
                endpoint = endpoint + "/" + component
            }
        }
        
        let request = Request(method: method, uri: endpoint)
        var queryObject = Node.object(defaultQuery)
        
        try query.forEach { (key: String, value: String) in
            try queryObject.set(key, value)
        }
        
        request.query = queryObject
        
        ///Encode model to request Body as JSON
        ///
        if model != nil {
            _ = try request.encodeJSONBody(model, using: encoder)
            
            //Having issues with sending dates into Graph API
            //
            //let requestData: Data = Data(bytes: request.body.bytes ?? [])
            //print(String(data: requestData, encoding: .utf8)!)
            
        }
        
        
        ///Add authentication bearer token to request
        ///
        try request.addBearerToken(config)
        
        ///Create Call
        ///
        let response = try client.respond(to: request)
        
        ///Grab body of response call to decode
        ///
        let data: Data = Data(bytes: response.body.bytes ?? [])
        
        //HANDLE STATUS ERRORS
        ///Set responseError to false if any acceptable Status comes back from response
        var responseError: Bool
        
        switch response.status {
        case .accepted, .created, .ok, .noContent:
            responseError = false
        default:
            responseError = true
        }
        ///If responseError is true, throw Error
        if responseError {
            
            let errorResponse = try decoder.decode(GraphErrorResponse.self, from: data)
            let graphError = MicrosoftGraphError.init(response.status,
                                                      reason: errorResponse.error.message)
            throw graphError
        }
        
        //SET RESULT RETURN
        ///Set result from below switch method
        var result: T
        
        switch method {
        case .patch:
            guard let modelData = model else {
                throw MicrosoftGraphError.decodingError
            }
            result = modelData
            
            
        case .post, .delete:
            ///In post call, return the model back from the response data
            ///If response status has noContent to return, just return the passed in model
            if response.status == .noContent{
                guard let m = model else {
                    throw MicrosoftGraphError.unknown
                }
                result = m
            } else {
                let modelData = try decoder.decode(T.self, from: data)
                result = modelData
            }
            
        default:
            ///Decode embedded object from Microsoft Graph Response
            let apiResponse = try decoder.decode(MicrosoftGraphResponse<T>.self, from: data)
            
            ///If response is embedded in 'Value' key, extract using MicrosoftGraphResponse,
            ///otherwise use the default model decoder
            
            var modelData: T
            
            if let m = apiResponse.value {
                modelData = m
            }else{
                modelData = try decoder.decode(T.self, from: data)
            }
            result = modelData
        }
        
        return result
    }
    
    func makeSelectQuery(_ selectKeys: [String]) -> String{
        var fields = selectKeys
        fields.append("id")
        return fields.joined(separator: ",")
    }
    
    
    
    ///Separated Response from makeRequest - need to figure out passing model into response
    ///
    func makeResponse(_ pathComponents: [String]? = nil,
                      query: [String: String] = [:],
                      method: HTTP.Method = .get) throws -> Response {
        
        ///From MicrosoftGraphConfig struct. Set in MicrosoftGraph wrapper.
        ///In this case: login.microsoftonline.com + baseUrl from specific Processor class
        var endpoint = config.instance + baseUrl
        
        ///Set default date decoding strategy from custom DateTypeFormatter
        decoder.dateDecodingStrategy = .formatted(DateFormatter.graphDate)
        encoder.dateEncodingStrategy = .formatted(DateFormatter.graphDate)
        
        ///adds optional uri components to baseUri
        if let p = pathComponents{
            for component in p{
                endpoint = endpoint + "/" + component
            }
        }
        
        let request = Request(method: method, uri: endpoint)
        var queryObject = Node.object(defaultQuery)
        
        try query.forEach { (key: String, value: String) in
            try queryObject.set(key, value)
        }
        
        request.query = queryObject
        
        ///Encode model to request Body as JSON
        ///
        //        if model != nil {
        //            _ = try request.encodeJSONBody(model, using: encoder)
        
        //Having issues with sending dates into Graph API
        //
        //let requestData: Data = Data(bytes: request.body.bytes ?? [])
        //print(String(data: requestData, encoding: .utf8)!)
        
        //}
        
        
        ///Add authentication bearer token to request
        ///
        try request.addBearerToken(config)
        
        ///Create Call
        ///
        let response = try client.respond(to: request)
        
        return response
    }
    
    
    
    ///Handle list of objects with paging. only 1 page supported at the moment
    ///
    func processObjects<T: Codable>(response: Response, method: HTTP.Method) throws -> [T]{
        
        ///Grab body of response call to decode
        ///
        let data: Data = Data(bytes: response.body.bytes ?? [])
        
        ///HANDLE STATUS ERRORS
        ///Set responseError to false if any acceptable Status comes back from response
        ///
        var responseError: Bool
        
        switch response.status {
        case .accepted, .created, .ok, .noContent:
            responseError = false
        default:
            responseError = true
        }
        ///If responseError is true, throw Error
        if responseError {
            
            let errorResponse = try decoder.decode(GraphErrorResponse.self, from: data)
            let graphError = MicrosoftGraphError.init(response.status,
                                                      reason: errorResponse.error.message)
            throw graphError
        }
        
        
        //SET RESULT RETURN
        ///Set result from below switch method
        var result: [T]
        
        
        ///Decode embedded object from Microsoft Graph Response
        let graphResponse = try decoder.decode(MicrosoftGraphResponse<[T]>.self, from: data)
        
        ///If response is embedded in 'Value' key, extract using MicrosoftGraphResponse,
        ///otherwise use the default model decoder
        
        
        guard let objects = graphResponse.value else {
            throw MicrosoftGraphError.decodingError
        }
        
        if let pagedLink = graphResponse.nextLink {
            var pagedObjects: [T] = []
            
            let pagedRequest = Request(method: .get, uri: pagedLink)
            
            ///Add authentication bearer token to request
            ///
            try pagedRequest.addBearerToken(config)
            
            let pagedResponse = try client.respond(to: pagedRequest)
            
            ///Grab body of response call to decode
            ///
            let data: Data = Data(bytes: pagedResponse.body.bytes ?? [])
            
            let decodedResponse = try decoder.decode(MicrosoftGraphResponse<[T]>.self, from: data)
            
            if let p = decodedResponse.value {
                pagedObjects = p
            }
            
            result = objects + pagedObjects
            
        } else {
            result = objects
        }
        
        ///
        return result
        
    }
    
}




