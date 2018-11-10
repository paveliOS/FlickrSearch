import Foundation

// Make HTTP requests conform to this protocol to use HTTPRequestService
protocol HTTPRequest {
    var url: URL { get }
    var requestMethod: HTTPRequestService.RequestMethod { get }
    var parameters: [String : Any] { get }
    var encoding: HTTPRequestService.RequestParameterEncoding { get }
}
