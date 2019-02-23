import Foundation
import UIKit

class WeatherListTableViewController: UITableViewController {
    var viewModel = WeatherListViewModel()
    var noDataView: UIView?
    var notificationCenter: NotificationCenter = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: To VM
        title = "Voor die wind"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        viewModel.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        
        // TODO: To VM
        noDataView = NoDataView(with: "Geen stede in jou voer?",
                                message: "Wil jy nie dalk soek vir jou gunsteling stad nie?",
                                image: UIImage(named: "umbrella") ?? UIImage(),
                                buttonTitle: "Soek 'n stad") { [weak self] in
            self?.showAddCity()
        }
        
        notificationCenter.addObserver(self, selector: #selector(updateLoadingStatus(_:)), name: .weatherUpdated, object: nil)
    }
}

// MARK: - Table view data source
extension WeatherListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Break out to own method
        if viewModel.numberOfRows > 0 {
            tableView.backgroundView  = nil
            tableView.separatorStyle  = .singleLine
        } else {
            tableView.backgroundView  = noDataView
            tableView.separatorStyle  = .none
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
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - Remove cell
extension WeatherListTableViewController: WeatherListViewModelDelegate {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title: "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.showDeleteAlert(for: indexPath)
            success(true)
        })
        
        modifyAction.backgroundColor = .red
        modifyAction.title = "Verwyder"
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    func showDeleteAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Is jy seker?", message: "Het jy vrede gemaak, die stad gaan nou jou voer verlaat", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Gaan voort", style: .destructive, handler: { [weak self] _ in
            self?.removeRow(at: indexPath)
        })
        let cancelAction = UIAlertAction(title: "Gaan terug", style: .default, handler: nil)
        
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
                    print("Still busy with \(cell.viewModel?.cityName)")
                    return
                } else {
                    print("Done updating \(cell.viewModel?.cityName)")
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
    
    func showDetail() {
        //        let model = WeatherListCellViewModel(with: "Welkom", latitude: 51.5171, longitude: -0.1062)
        //        model.getWeather()
        //        let vc = WeatherDetailTableViewController(with: model)
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    // For convenience only
    func showAddCity() {
        performSegue(withIdentifier: "showAddCity", sender: self)
    }
}

