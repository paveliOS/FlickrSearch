import Foundation

final class ResponseFlickrPhotos: Decodable {
    
    let photos: [FlickrPhoto]
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    
    init(photos: [FlickrPhoto], page: Int, pages: Int, perpage: Int, total: Int) {
        self.photos = photos
        self.page = page
        self.pages = pages
        self.perpage = perpage
        self.total = total
    }
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
    
    enum PhotosKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case total
        case photo
    }
    
    init(from decoder: Decoder) throws {
        let photosContainer = try decoder.container(keyedBy: CodingKeys.self)
        let values = try photosContainer.nestedContainer(keyedBy: PhotosKeys.self, forKey: .photos)
        
        photos = try values.decode(Array<FlickrPhoto>.self, forKey: PhotosKeys.photo)
        page = try values.decode(Int.self, forKey: PhotosKeys.page)
        pages = try values.decode(Int.self, forKey: PhotosKeys.pages)
        perpage = try values.decode(Int.self, forKey: PhotosKeys.perpage)
        // Total can be returned as String/Int
        do {
            total = try values.decode(Int.self, forKey: PhotosKeys.total)
        } catch {
            total = Int(try values.decode(String.self, forKey: PhotosKeys.total)) ?? 0
        }
    }
    
}

extension ResponseFlickrPhotos: ImageResponse {
    
    var images: [Image] {
        return photos
    }
    
}
