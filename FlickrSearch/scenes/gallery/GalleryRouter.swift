import UIKit

protocol GalleryRouterProtocol: class {}

// Links the Gallery MVP module, responsible for navigation to other modules
final class GalleryRouter {
    
    private static let storyboardName = "Gallery"
    
    static func setupGalleryModule(title: String, imageSource: ImageSourceAPI) -> UIViewController {
        let router = GalleryRouter()
        let view = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController() as! GalleryViewController
        let presenter = GalleryPresenter(view: view, router: router, imageSource: imageSource, title: title)
        view.presenter = presenter
        let navVC = UINavigationController(rootViewController: view)
        return navVC
    }
    
}

extension GalleryRouter: GalleryRouterProtocol {}
