import UIKit

protocol GalleryView: class {}

final class GalleryViewController: UIViewController {
    
    var presenter: GalleryViewPresenter!
    
}

extension GalleryViewController: GalleryView {}
