
import Foundation
import UIKit

protocol CitySearchTableViewControllerDelegate {
    func citySearch(_ tableView: CitySearchTableViewController, didSelect city: CityModel)
}

class CitySearchTableViewController : UITableViewController {
    let searchController = CustomSearchController(searchResultsController: nil) // nil -> use this view
    var delegate: CitySearchTableViewControllerDelegate?
    var viewModel = CitySearchListViewModel()
    var noDataView: NoDataView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpSearchController()
        setUpBinding()
        setUpNoDataView()
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

// MARK: - Private
extension CitySearchTableViewController {
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
    
    private func setUpNoDataView() {
        noDataView = NoDataView(with: viewModel.noDataTitle,
                                message: viewModel.noDataMessage,
                                image: viewModel.noDataImage,
                                buttonTitle: nil,
                                shouldShowButton: false,
                                buttonHandler: nil)
    }
    
    private func showAddAlert() {
        let alert = UIAlertController(title: viewModel.addAlertTitle, message: viewModel.addAlertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: viewModel.addAlertCancel, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setUpBinding() {
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
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

// MARK: - Table view datasource
extension CitySearchTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfRows > 0 {
            tableView.backgroundView  = nil
            tableView.separatorStyle  = .singleLine
        } else {
            tableView.backgroundView  = noDataView
            tableView.separatorStyle  = .none
        }
        return viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") else { return UITableViewCell() }
        cell.textLabel?.text = viewModel.cellTitle(for: indexPath.row)
        cell.detailTextLabel?.text = viewModel.cellSubtitle(for: indexPath.row)
        cell.isUserInteractionEnabled = viewModel.isUserInteractionEnabled(for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - Table view delegate
extension CitySearchTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let city = viewModel.city(for: indexPath.row) else { return }
        
        if !CityWeatherStore.shared.contains(city.identifier) {
            delegate?.citySearch(self, didSelect: city)
            self.dismissViewController()
        } else {
            showAddAlert()
        }
    }
}

// MARK: - SearchController delegate
extension CitySearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
         viewModel.search(for: searchController.searchBar.text)
    }
}

// MARK: - Helpers
extension CitySearchTableViewController {
    private func delay(_ delay: Double, closure: @escaping ()->()) {
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

