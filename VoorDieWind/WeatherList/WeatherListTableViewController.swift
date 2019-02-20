import Foundation
import UIKit

class WeatherListTableViewController: UITableViewController {
    var viewModel = WeatherListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: To VM
        title = "Voor die wind"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        viewModel.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell,
            let weatherViewModel = viewModel.weatherViewModel(for: indexPath.row)
        else { return UITableViewCell() }
        
        cell.setUpCell(with: weatherViewModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func showAddCity() {
       performSegue(withIdentifier: "showAddCity", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nav = segue.destination as? UINavigationController,
            let vc = nav.viewControllers.first as? CitySearchTableViewController else { return }
        
        vc.delegate = self
    }
}

extension WeatherListTableViewController: CitySearchTableViewControllerDelegate {
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

