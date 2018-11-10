import Foundation

// Make HTTP requests conform to this protocol to use HTTPRequestService
protocol HTTPRequest: Encodable {
    var url: URL { get }
    var requestMethod: HTTPRequestService.RequestMethod { get }
    var parameters: [String : Any] { get }
    var encoding: HTTPRequestService.RequestParameterEncoding { get }
}

extension HTTPRequest {
    
    // Default implementation of request properties conversion to a dictionary
    var parameters: [String : Any] {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self)
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: [])
            return jsonDict as! [String : Any]
        } catch {
            NSLog("Failed to encode \(type(of: self)) parameters with error: \(error.localizedDescription)")
            return [:]
        }
    }
    
}
