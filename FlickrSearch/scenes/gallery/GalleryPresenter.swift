import Foundation

protocol GalleryViewPresenter: class {
    var images: [Image] { get }
    func viewDidLoad()
    func onSearchAction(query: String)
    func onCancelSearchAction()
}

final class GalleryPresenter {
    
    private weak var view: GalleryView?
    private let router: GalleryRouterProtocol
    private var imageList: [Image]
    
    init(view: GalleryView?, router: GalleryRouterProtocol) {
        self.view = view
        self.router = router
        imageList = []
    }
    
}

extension GalleryPresenter: GalleryViewPresenter {
    
    var images: [Image] {
        return imageList
    }
    
    func viewDidLoad() {
        
    }
    
    func onSearchAction(query: String) {
        
    }
    
    func onCancelSearchAction() {
        
    }
    
}

