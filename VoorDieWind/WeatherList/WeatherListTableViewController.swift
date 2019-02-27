import Foundation
import UIKit

class WeatherListTableViewController: UITableViewController {
    private var noDataView: UIView?
    private var weatherUpdateObserver: NSObjectProtocol?
    
    var viewModel = WeatherListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        viewModel.delegate = self
        
        setUpNavigationBar()
        setUpRefreshControl()
        setUpNoDataView()
        setUpNotification()
    }
    
    deinit {
        if let observer = weatherUpdateObserver {
            NotificationCenter.default.removeObserver(weatherUpdateObserver)
        }
    }
}

// MARK: - Private
extension WeatherListTableViewController {
    private func setUpNavigationBar() {
          self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
    }
    
    private func setUpNoDataView() {
        noDataView = NoDataView(with: viewModel.noDataTitle,
                                message: viewModel.noDataMessage,
                                image: viewModel.noDataImage,
                                buttonTitle: viewModel.noDataButtonTitle) { [weak self] in self?.showAddCity() }
    }

    private func setUpNotification() {
        weatherUpdateObserver = NotificationCenter.default.addObserver(forName: .weatherUpdated,
                                                                       object: nil,
                                                                       queue: OperationQueue.main,
                                                                       using: { [weak self] (notification) in                                                                        self?.updateLoadingStatus(notification)
        })
    }
    
    private func showNoDataView() {
        tableView.backgroundView  = noDataView
        tableView.separatorStyle  = .none
    }
    
    private func hideNoDataView() {
        tableView.backgroundView  = nil
        tableView.separatorStyle  = .singleLine
    }
}

// MARK: - Table view data source
extension WeatherListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfRows > 0 {
           hideNoDataView()
        } else {
           showNoDataView()
        }
        return viewModel.numberOfRows
    }
}

// MARK: - Footer
extension WeatherListTableViewController {
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - Cells
extension WeatherListTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherListCell,
            let cityWeather = viewModel.cityWeather(for: indexPath)
            else { return UITableViewCell() }
        
        let cellViewModel = WeatherListCellViewModel(with: cityWeather)
        cell.setUpCell(with: cellViewModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cityWeather = self.viewModel.cityWeather(for: indexPath) {
            let viewModel = WeatherDetailViewModel(with: cityWeather)
            let vc = WeatherDetailTableViewController(with: viewModel)
            navigationItem.backBarButtonItem = UIBarButtonItem()
            navigationItem.backBarButtonItem?.title = viewModel.backButtonTitle
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // TODO: check if we can display the detail weather
        return true
    }
}

// MARK: - Remove cell
extension WeatherListTableViewController: WeatherListViewModelDelegate {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: viewModel.deleteButtonTitle, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.showDeleteAlert(for: indexPath)
            success(true)
        })
        
        deleteAction.backgroundColor = viewModel.deleteButtonColor
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func showDeleteAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: viewModel.deleteAlertTitle, message: viewModel.deleteAlertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: viewModel.deleteAlertConfirmation, style: .destructive, handler: { [weak self] _ in
            self?.removeRow(at: indexPath)
        })
        let cancelAction = UIAlertAction(title: viewModel.deleteAlertCancel, style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func removeRow(at indexPath: IndexPath) {
        viewModel.removeCity(at: indexPath)
    }
    
    func weatherList(_ viewModel: WeatherListViewModel, didRemove indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
    }
}

// MARK: - City search
extension WeatherListTableViewController: CitySearchTableViewControllerDelegate {
    func citySearch(_ tableView: CitySearchTableViewController, didSelect city: CityModel) {
            viewModel.addCity(city)
            self.tableView.reloadData()
    }
}

// MARK: - Refresh
extension WeatherListTableViewController {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if viewModel.numberOfRows <= 0 {
            refreshControl.endRefreshing()
            return
        }
        
        for row in 0..<viewModel.numberOfRows {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))  as? WeatherListCell {
                cell.updateWeather()
            }
        }
    }
    
    @objc func updateLoadingStatus(_ notification: Notification) {
        for row in 0..<viewModel.numberOfRows {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))  as? WeatherListCell {
                if cell.isCelUpdating {
                    print("Still busy with \(String(describing: cell.viewModel?.cityName))")
                    return
                } else {
                    print("Done updating \(String(describing: cell.viewModel?.cityName))")
                }
            }
        }
        print("Finished update")
        refreshControl?.endRefreshing()
    }
}

// MARK: - Segues
extension WeatherListTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController,
            let vc = nav.viewControllers.first as? CitySearchTableViewController else { return }
        vc.delegate = self
    }
    
    func showAddCity() {
        performSegue(withIdentifier: "showAddCity", sender: self)
    }
}

