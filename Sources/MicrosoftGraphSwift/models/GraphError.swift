public struct GraphErrorResponse: Decodable {
    var error: GraphError
    
    struct GraphError: Decodable {
        var code: String?
        var message: String?
        var innerError: GraphInnerError
    }
    
    struct GraphInnerError: Decodable {
        var requestId: String?
        var date: String?
        
        enum CodingKeys: String, CodingKey {
            case requestId = "request-id"
            case date
        }
    }
    
}
