import Kingfisher

final class ImageCell: UICollectionViewCell {
    
    @IBOutlet private var imageView: UIImageView!
    
}

extension ImageCell {
    
    static let identifier = "Image"
    
    var image: UIImage? {
        return imageView?.image
    }
    
    func setData(url: URL?) {
        imageView.kf.setImage(with: url, options: [.transition(.fade(0.4))])
    }
    
}
