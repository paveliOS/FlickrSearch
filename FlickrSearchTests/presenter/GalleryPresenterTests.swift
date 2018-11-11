import XCTest
@testable import FlickrSearch

class GalleryPresenterTests: XCTestCase {
    
    var galleryView: MockGalleryView!
    var router: MockGalleryRouter!
    var imageSource: MockImageSource!
    var instance: GalleryPresenter!

    override func setUp() {
        galleryView = MockGalleryView()
        router = MockGalleryRouter()
        imageSource = MockImageSource()
        let persistenceManager = MockPersistenceManager()
        instance = GalleryPresenter(view: galleryView, router: router, imageSource: imageSource, persistenceManager: persistenceManager)
    }

    override func tearDown() {
        instance = nil
    }

    func testInitialDataSetting() {
        let exp = expectation(description: "Initial data must be set after view is loaded")
        galleryView.dataSettingExpectation = exp
        instance.viewDidLoad()
        wait(for: [exp], timeout: 1)
    }
    
    func testInitialImageFetch() {
        instance.viewDidLoad()
        XCTAssert(imageSource.fetchWasInitiated, "Data must be fetched from the image source after view is loaded")
    }
    
    func testImageFetchAfterUserScrolledToBottom() {
        instance.userDidScrollToBottom()
        XCTAssert(imageSource.fetchWasInitiated, "Data must be fetched from the image source after user scrolled to bottom")
    }
    
    func testImageFetchAfterUserCanceledSearch() {
        instance.cancelSearch()
        XCTAssert(imageSource.fetchWasInitiated, "Data must be fetched from the image source after user canceled search")
    }
    
    func testProgressAppearanceOnImageSearch() {
        let exp = expectation(description: "Progress must be displayed when image data is fetched from the image source")
        galleryView.progressAppearanceExpectation = exp
        instance.searchPhotos(with: "query")
        wait(for: [exp], timeout: 1)
    }
    
    func testProgressEventualDismissalAfterImageSearch() {
        let exp = expectation(description: "Progress must be eventually dismissed after image data is fetched from the image source")
        galleryView.progressDismissalExpectation = exp
        instance.searchPhotos(with: "query")
        wait(for: [exp], timeout: 1)
    }
    
    func testCollectionUpdateAfterImageSearch() {
        let exp = expectation(description: "Collection view must be updated after image data is fetched from the image source")
        galleryView.collectionUpdateExpectation = exp
        instance.searchPhotos(with: "query")
        wait(for: [exp], timeout: 1)
    }
    
    func testCollectionScrollingToTopAfterImageSearch() {
        let exp = expectation(description: "Collection view must be must be scrolled to top after image search")
        galleryView.collectionScrollingToTopExpectation = exp
        instance.searchPhotos(with: "query")
        wait(for: [exp], timeout: 1)
    }
    
    func testAlertPresentationOnUnsuccessfulImageSearch() {
        let exp = expectation(description: "Alert must be displayed to user on unsuccessful image search attempt")
        galleryView.alertExpectation = exp
        imageSource.responseIsSuccessful = false
        instance.searchPhotos(with: "query")
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: MOCK
    
    class MockPersistenceManager: GalleryPersistenceManager {
        var searchQueries: [String] = []
    }
    
    class MockImageResponse: ImageResponse {
        var images: [Image] = []
        var page: Int = 0
        var pages: Int = 0
        var perpage: Int = 0
        var total: Int = 0
    }
    
    class MockImageSource: ImageSourceAPI {
        var fetchWasInitiated = false
        var responseIsSuccessful = true
        func load(query: String?, page: Int?, perPage: Int, callback: ((ImageResponse?) -> Void)?) {
            fetchWasInitiated = true
            callback?(responseIsSuccessful ? MockImageResponse() : nil)
        }
    }
    
    class MockGalleryRouter: GalleryRouterProtocol {}
    
    class MockGalleryView: GalleryView {
        
        var dataSettingExpectation: XCTestExpectation?
        var collectionUpdateExpectation: XCTestExpectation?
        var progressAppearanceExpectation: XCTestExpectation?
        var progressDismissalExpectation: XCTestExpectation?
        var collectionScrollingToTopExpectation: XCTestExpectation?
        var alertExpectation: XCTestExpectation?
        
        func setData(viewData: GalleryViewData) {
            dataSettingExpectation?.fulfill()
        }
        
        func updateCollection(oldData: [ImageViewData], newData: [ImageViewData]) {
            collectionUpdateExpectation?.fulfill()
        }
        
        func scrollCollectionToTop() {
            collectionScrollingToTopExpectation?.fulfill()
        }
        
        func displayProgress() {
            progressAppearanceExpectation?.fulfill()
        }
        
        func displayAlert(message: String) {
            alertExpectation?.fulfill()
        }
        
        func dismissProgress() {
            progressDismissalExpectation?.fulfill()
        }
        
        
    }
    
}
