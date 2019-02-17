
import Foundation
import UIKit

protocol CitySearchTableViewControllerDelegate {
    func addCity(_ tableView: AddCityTableViewController, didSelect city: CitySearchViewModel)
}

class AddCityTableViewController : UITableViewController {
    let searchController = CustomSearchController(searchResultsController: nil) // nil -> use this view
    var delegate: CitySearchTableViewControllerDelegate?
    var viewModel = CitySearchListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpSearchController()
        setUpBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delay(0.1) {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    @objc func dismissViewController() {
        searchController.isActive = false
        dismiss(animated: true, completion: nil)
    }
}

extension AddCityTableViewController {
    private func setUpNavigationBar() {
        navigationItem.prompt = viewModel.navigationPrompt
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.cancelButton, style: .plain, target: self, action: #selector(dismissViewController))
    }
    
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        // searchbar
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = viewModel.searchPlaceHolder
        navigationItem.titleView = searchController.searchBar
    }
}

// MARK: - Table view datasource
extension AddCityTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") else { return UITableViewCell() }
        cell.textLabel?.text = viewModel.cellTitle(for: indexPath.row)
        cell.detailTextLabel?.text = viewModel.cellSubtitle(for: indexPath.row)
        return cell
    }
}

// MARK: - Table view delegate
extension AddCityTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let city = viewModel.city(for: indexPath.row) else { return }
        delegate?.addCity(self, didSelect: city)
        self.dismissViewController()
    }
}

// MARK: - SearchController delegate
extension AddCityTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
         viewModel.search(for: searchController.searchBar.text)
    }
}

// MARK: - Binding
extension AddCityTableViewController {
    func setUpBinding() {
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                // TODO: set whether cell is selctable or not
                self?.tableView.reloadData()
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] (isLoading) in
            DispatchQueue.main.async {
                self?.searchController.searchBar.isLoading = isLoading
            }
        }
    }
}

// MARK: - Helpers
extension AddCityTableViewController {
    func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}


// Needed beacuase of some bug where cancel button wont dissapear
class CustomSearchController: UISearchController {
    let customSearchBar = CustomSearchBar()
    override var searchBar: UISearchBar {
        return customSearchBar
    }
}

class CustomSearchBar: UISearchBar {
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        //
    }
}

