import Foundation

final class RequestFlickrPhotos {
    
    let api_key: String
    let method: String
    var text: String?
    var tags: String?
    var privacy_filter: Int?
    var format: String?
    var nojsoncallback: Int?
    var safe_search: Int?
    var page: Int?
    var per_page: Int?
    var extras: String?
    
    private init(api_key: String, method: String) {
        self.api_key = api_key
        self.method = method
        privacy_filter = 1
        format = "json"
        nojsoncallback = 1
        safe_search = 1
        extras = "url_m"
    }
    
    // Search
    convenience init(api_key: String, text: String) {
        self.init(api_key: api_key, method: "flickr.photos.search")
        self.text = text
    }
    
    // Recent
    convenience init(api_key: String) {
        self.init(api_key: api_key, method: "flickr.photos.getRecent")
    }
    
}

extension RequestFlickrPhotos: HTTPRequest {
    
    var url: URL {
        return URL(string: Flickr.url)!
    }
    
    var requestMethod: HTTPRequestService.RequestMethod {
        return .get
    }
    
    var encoding: HTTPRequestService.RequestParameterEncoding {
        return .url
    }
    
}
