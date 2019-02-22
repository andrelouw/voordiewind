import Foundation
import UIKit

class WeatherListTableViewController: UITableViewController {
    var viewModel = WeatherListViewModel()
    var noDataView: UIView?
    
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
    }
    
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell,
            let weatherViewModel = viewModel.weatherViewModel(for: indexPath.row)
        else { return UITableViewCell() }
        
        cell.setUpCell(with: weatherViewModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title: "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.showDeleteAlert(for: indexPath)
            success(true)
        })
        
        modifyAction.backgroundColor = .red
        modifyAction.title = "Verwyder"
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let viewModel = self.viewModel.city(for: indexPath.row) {
            let vc = WeatherDetailTableViewController(with: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nav = segue.destination as? UINavigationController,
            let vc = nav.viewControllers.first as? CitySearchTableViewController else { return }
        
        vc.delegate = self
    }
}

// MARK: - City search
extension WeatherListTableViewController: CitySearchTableViewControllerDelegate {
    // For convenience only
    func showAddCity() {
        performSegue(withIdentifier: "showAddCity", sender: self)
    }
    
    func citySearch(_ tableView: CitySearchTableViewController, didSelect city: CitySearchViewModel) {
        viewModel.addCity(city)
        self.tableView.reloadData()
    }
    
    func citySearch(_ tableView: CitySearchTableViewController, shouldAdd city: CitySearchViewModel) -> Bool {
        return !viewModel.contains(city)
    }
}

// MARK: - Refresh
extension WeatherListTableViewController: WeatherListViewModelDelegate {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        viewModel.updateWeatherList()
    }
    
    func weatherList(_ viewModel: WeatherListViewModel, didFinishUpdate: Bool) {
        if didFinishUpdate {
            print("Finished update")
            refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Remove cell
extension WeatherListTableViewController {
    @objc func removeRow(at indexPath: IndexPath) {
        viewModel.removeCity(at: indexPath.row)
    }
    
    func weatherList(_ viewModel: WeatherListViewModel, didRemove row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
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
}

// MARK: - Weather detail
extension WeatherListTableViewController {
    func showDetail() {
        let model = WeatherViewModel(with: "Welkom", latitude: 51.5171, longitude: -0.1062)
        model.getWeather()
        let vc = WeatherDetailTableViewController(with: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}

