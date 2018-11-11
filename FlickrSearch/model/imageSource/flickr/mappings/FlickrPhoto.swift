import Foundation

struct FlickrPhoto: Decodable, Image {
    
    let id: String?
    let owner: String?
    let secret: String?
    let server: String?
    let title: String?
    let farm: Int?
    let ispublic: Int?
    let isfriend: Int?
    let isfamily: Int?
    let url_m: String?
    let height_m: String?
    let width_m: String?
    
    var url: URL? {
        if let url = url_m {
            return URL(string: url)
        } else {
            return nil
        }
    }
    
}
