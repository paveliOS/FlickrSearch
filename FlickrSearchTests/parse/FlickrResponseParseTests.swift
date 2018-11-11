import XCTest
@testable import FlickrSearch

class FlickrResponseParseTests: XCTestCase {
    
    func testFlickrPhotoParsing() {
        do {
            let testBundle = Bundle(for: type(of: self))
            let flickrPhotoJSONData = try Data(contentsOf: testBundle.url(forResource: "FlickrPhoto", withExtension: "json")!)
            let decoder = JSONDecoder()
            let photo = try decoder.decode(FlickrPhoto.self, from: flickrPhotoJSONData)
            guard photo.id == "30887326267", photo.owner == "9149295@N05", photo.secret == "d39276fea6", photo.server == "4831", photo.farm == 5, photo.title == "", photo.ispublic == 1, photo.isfriend == 0, photo.isfamily == 0, photo.url_m == "https:\\/\\/farm5.staticflickr.com\\/4831\\/30887326267_d39276fea6.jpg", photo.height_m == "375", photo.width_m == "500" else {
                XCTFail("Failed to parse FlickrPhoto")
                return
            }
            XCTAssert(true)
        } catch {
            XCTFail("Failed to parse FlickrPhoto")
        }
    }

    func testFlickrPhotosResponseParsing() {
        do {
            let testBundle = Bundle(for: type(of: self))
            let flickrResponseJSONData = try Data(contentsOf: testBundle.url(forResource: "FlickrPhotosResponse", withExtension: "json")!)
            let decoder = JSONDecoder()
            let response = try decoder.decode(FlickrPhotosResponse.self, from: flickrResponseJSONData)
            guard response.page == 1, response.pages == 28, response.perpage == 36, response.total == 1000, response.images.count == 36 else {
                XCTFail("Failed to parse FlickrPhotosResponse")
                return
            }
            XCTAssert(true)
        } catch {
            XCTFail("Failed to parse FlickrPhotosResponse")
        }
    }

}
