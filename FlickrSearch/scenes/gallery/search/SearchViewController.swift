import UIKit

protocol SearchViewControllerDelegate: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {}

final class SearchViewController: UIViewController {
    
    private static let storyboardName = "Search"
    
    @IBOutlet private var searchResultsTableView: UITableView! {
        didSet {
            searchResultsTableView.delegate = delegate
            searchResultsTableView.dataSource = delegate
        }
    }
    
    @IBOutlet private var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = delegate
        }
    }
    
    weak var delegate: SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTableView.tableFooterView = UIView()
    }

}

extension SearchViewController {
    
    static func instantiate(delegate: SearchViewControllerDelegate) -> SearchViewController {
        let searchVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController() as! SearchViewController
        searchVC.delegate = delegate
        return searchVC
    }
    
}
