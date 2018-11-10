import Foundation

protocol GalleryViewPresenter: class {}

final class GalleryPresenter {
    
    private weak var view: GalleryView?
    private let router: GalleryRouterProtocol
    
    init(view: GalleryView?, router: GalleryRouterProtocol) {
        self.view = view
        self.router = router
    }
    
}

extension GalleryPresenter: GalleryViewPresenter {}

