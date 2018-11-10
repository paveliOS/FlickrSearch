import UIKit
import Diff
import ProgressHUD

protocol GalleryView: class {
    func setData(viewData: GalleryViewData)
    func updateCollection(oldData: [ImageViewData], newData: [ImageViewData])
    func scrollCollectionToTop()
    func displayProgress()
    func displayAlert(message: String)
    func dismissAlert()
}

final class GalleryViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    
    private var contentOffsetHeightRatio: CGFloat?
    
    var presenter: GalleryViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction private func actionSearch(_ sender: UIBarButtonItem) {
        let searchVC = SearchViewController.instantiate(delegate: self)
        searchVC.modalPresentationStyle = .popover
        searchVC.popoverPresentationController?.delegate = self
        searchVC.popoverPresentationController?.backgroundColor = .black
        searchVC.popoverPresentationController?.barButtonItem = sender
        present(searchVC, animated: true, completion: nil)
    }
    
    private func checkIfScrolledToBottom() {
        let bottomEdge = collectionView.contentOffset.y + collectionView.frame.size.height
        if bottomEdge >= collectionView.contentSize.height {
            presenter.userDidScrollToBottom()
        }
    }
    
    private func setup() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor.white,
            .font : UIFont.boldSystemFont(ofSize: 22)
        ]
    }
    
}

extension GalleryViewController: GalleryView {
    
    func setData(viewData: GalleryViewData) {
        navigationItem.title = viewData.title
    }
    
    func updateCollection(oldData: [ImageViewData], newData: [ImageViewData]) {
        collectionView.animateItemChanges(oldData: oldData, newData: newData)
    }
    
    func scrollCollectionToTop() {
        collectionView.setContentOffset(.zero, animated: false)
    }
    
    func displayProgress() {
        ProgressHUD.show()
    }
    
    func displayAlert(message: String) {
        ProgressHUD.showError(message)
    }
    
    func dismissAlert() {
        ProgressHUD.dismiss()
    }
    
}

extension GalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let ratio = contentOffsetHeightRatio else {
            return proposedContentOffset
        }
        contentOffsetHeightRatio = nil
        
        let newOffset = CGPoint(x: 0, y: ratio * collectionView.bounds.height)
        return newOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            checkIfScrolledToBottom()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkIfScrolledToBottom()
    }
    
}

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

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGSize
        if collectionView.bounds.width > collectionView.bounds.height {
            // Landscape
            size = CGSize(width: collectionView.bounds.width / 6, height: collectionView.bounds.height / 2)
        } else {
            size = CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height / 6)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension GalleryViewController: SearchViewControllerDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        presenter.onSearchAction(query: presenter.queries[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.queries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let query = presenter.queries[indexPath.row]
        cell.textLabel!.text = query
        cell.textLabel!.textColor = .white
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            dismiss(animated: true, completion: nil)
            presenter.onSearchAction(query: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.onCancelSearchAction()
    }
    
}

extension GalleryViewController: UIPopoverPresentationControllerDelegate {
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
