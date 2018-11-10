import UIKit

protocol GalleryView: class {}

final class GalleryViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    
    var presenter: GalleryViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction private func actionSearch(_ sender: UIBarButtonItem) {
        if let _ = navigationItem.searchController {
            hideSearchController()
        } else {
            presentSearchController()
        }
    }
    
    private func presentSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .white
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func hideSearchController() {
        if let _ = navigationItem.searchController {
            navigationItem.searchController = nil
        }
    }
    
}

extension GalleryViewController: GalleryView {}

extension GalleryViewController: UICollectionViewDelegate {}

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        let imageData = presenter.images[indexPath.row]
        imageCell.setData(url: imageData.url)
        return imageCell
    }
    
}

extension GalleryViewController: UISearchControllerDelegate {}

extension GalleryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            presenter.onSearchAction(query: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.onCancelSearchAction()
    }
    
}
