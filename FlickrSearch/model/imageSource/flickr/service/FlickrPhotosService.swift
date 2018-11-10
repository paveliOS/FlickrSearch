import Foundation

final class FlickrPhotosService {
    
    private let requestService: HTTPRequestServiceProtocol
    
    init() {
        requestService = HTTPRequestService()
    }
    
    private func requestPhotos(request: RequestFlickrPhotos, page: Int?, perPage: Int, callback: ((ResponseFlickrPhotos?) -> Void)?) {
        request.page = page
        request.per_page = perPage
        requestService.execute(request: request) { response in
            switch response {
            case .success(data: let data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ResponseFlickrPhotos.self, from: data)
                    callback?(result)
                } catch {
                    NSLog("Failed to decode search flickr photos response JSON with error: \(error.localizedDescription)")
                    callback?(nil)
                }
            case .failure(error: let error):
                switch error {
                case .connection(description: let descr):
                    NSLog(descr)
                    callback?(nil)
                }
            }
        }
    }
    
}

extension FlickrPhotosService: ImageSourceAPI {
    
    func load(query: String?, page: Int?, perPage: Int, callback: ((ImageResponse?) -> Void)?) {
        let request: RequestFlickrPhotos
        if let q = query {
            request = RequestFlickrPhotos(api_key: Flickr.apiKey, text: q)
        } else {
            request = RequestFlickrPhotos(api_key: Flickr.apiKey)
        }
        requestPhotos(request: request, page: page, perPage: perPage, callback: callback)
    }
    
}
