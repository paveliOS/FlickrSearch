import Foundation

protocol GalleryViewPresenter: class {
    var images: [ImageViewData] { get }
    var queries: [String] { get }
    func viewDidLoad()
    func userDidScrollToBottom()
    func searchPhotos(with query: String)
    func cancelSearch()
}

final class GalleryPresenter {
    
    private weak var view: GalleryView?
    private let router: GalleryRouterProtocol
    private var imageList: [ImageViewData]
    private var loading: Bool
    private let imageSource: ImageSourceAPI
    private let persistenceManager: GalleryPersistenceManager
    private var query: String?
    private var page: Int
    private let title: String
    
    init(view: GalleryView?, router: GalleryRouterProtocol, imageSource: ImageSourceAPI, persistenceManager: GalleryPersistenceManager = UserDefaults.standard, title: String = "Title") {
        self.view = view
        self.router = router
        self.imageList = []
        self.loading = false
        self.imageSource = imageSource
        self.persistenceManager = persistenceManager
        self.page = 0
        self.title = title
    }
    
    private func loadPhotos(query: String?, callback: @escaping ([ImageViewData]) -> Void) {
        let imagesPerPage = 36
        page += 1
        imageSource.load(query: query, page: page, perPage: imagesPerPage) { response in
            if let r = response {
                self.page = r.page
                let viewData = r.images.map { ImageViewData(url: $0.url) }
                DispatchQueue.main.async {
                    callback(viewData)
                }
            } else {
                DispatchQueue.main.async {
                    self.view?.displayAlert(message: "Request failed :(")
                }
            }
        }
    }
    
    private func loadRecentPhotos() {
        view?.displayProgress()
        loadPhotos(query: nil) { photos in
            let oldList = self.imageList
            self.imageList = photos
            self.view?.dismissProgress()
            self.view?.scrollCollectionToTop()
            self.view?.updateCollection(oldData: oldList, newData: self.imageList)
        }
    }
    
}

extension GalleryPresenter: GalleryViewPresenter {
    
    var images: [ImageViewData] {
        return imageList
    }
    
    var queries: [String] {
        return UserDefaults.standard.searchQueries
    }
    
    func viewDidLoad() {
        let viewData = GalleryViewData(title: self.title)
        view?.setData(viewData: viewData)
        loadRecentPhotos()
    }
    
    func userDidScrollToBottom() {
        if !loading {
            loading = true
            loadPhotos(query: query) { photos in
                let old = self.imageList
                self.imageList = old + photos
                self.view?.updateCollection(oldData: old, newData: self.imageList)
                self.loading = false
            }
        }
    }
    
    func searchPhotos(with query: String) {
        var searchHistory = persistenceManager.searchQueries
        if let indexOfExistingQuery = searchHistory.firstIndex(of: query) {
            // Remove query from history if it exists
            searchHistory.remove(at: indexOfExistingQuery)
        }
        searchHistory.insert(query, at: 0)
        persistenceManager.searchQueries = searchHistory
        view?.displayProgress()
        if self.query != query {
            self.query = query
            page = 0
        }
        loadPhotos(query: query) { photos in
            let old = self.imageList
            self.imageList = photos
            self.view?.dismissProgress()
            if photos.isEmpty {
                self.view?.displayAlert(message: "No images were found :(")
            }
            self.view?.scrollCollectionToTop()
            self.view?.updateCollection(oldData: old, newData: self.imageList)
        }
    }
    
    func cancelSearch() {
        query = nil
        page = 0
        loadRecentPhotos()
    }
    
}

