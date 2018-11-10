import Alamofire

protocol HTTPRequestServiceProtocol: class {
    func execute(request: HTTPRequest, responseHandler: ((HTTPRequestService.Response) -> Void)?)
}

// Abstraction layer between the target and Alamofire
final class HTTPRequestService {}

extension HTTPRequestService: HTTPRequestServiceProtocol {
    
    func execute(request: HTTPRequest, responseHandler: ((Response) -> Void)?) {
        let request = Alamofire.request(request.url, method: request.requestMethod.alamofire, parameters: request.parameters, encoding: request.encoding.alamofire)
        NSLog("Sending: \(request.debugDescription)")
        request.responseJSON { response in
            guard response.error == nil else {
                NSLog("HTTP request failed with error: \(response.error!.localizedDescription)")
                let error = ServiceError.connection(description: response.error!.localizedDescription)
                responseHandler?(Response.failure(error: error))
                return
            }
            
            guard let resp = response.response else {
                NSLog("HTTP request failed with error: response object is nil")
                let error = ServiceError.connection(description: "Response is nil")
                responseHandler?(Response.failure(error: error))
                return
            }
            
            NSLog("HTTP Response statusCode: \(resp.statusCode)")
            
            guard let data = response.data else {
                NSLog("Failed to receive response data")
                let error = ServiceError.connection(description: "No response data")
                responseHandler?(Response.failure(error: error))
                return
            }
            
            if let responseString = String(data: data, encoding: String.Encoding.utf8) {
                NSLog("HTTP Response string: \(responseString)")
            } else {
                NSLog("HTTP Response is not a string")
            }
            
            guard resp.statusCode == 200 else {
                let error = ServiceError.connection(description: "Status code: \(resp.statusCode)")
                responseHandler?(Response.failure(error: error))
                return
            }
            
            responseHandler?(Response.success(data: data))
        }
    }
    
}

// Related mappings
extension HTTPRequestService {
    
    enum RequestMethod {
        case get
        case post
        case delete
        
        fileprivate var alamofire: HTTPMethod {
            switch self {
            case .get:
                return .get
            case .post:
                return .post
            case .delete:
                return .delete
            }
        }
    }
    
    enum RequestParameterEncoding {
        case url
        case json
        
        fileprivate var alamofire: ParameterEncoding {
            switch self {
            case .url:
                return URLEncoding.default
            case .json:
                return JSONEncoding.default
            }
        }
    }
    
    enum Response {
        case success(data: Data)
        case failure(error: ServiceError)
    }
    
    enum ServiceError: Error {
        case connection(description: String)
    }
    
}
