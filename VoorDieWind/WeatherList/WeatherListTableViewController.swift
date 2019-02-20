import Foundation
import UIKit

class WeatherListTableViewController: UITableViewController {
    var viewModel = WeatherListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: To VM
        title = "Voor die wind"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Each cell needs to do this, so WatherViewModel needs to do this
//        WeatherService().get(.weather, for: "19.7872,-101.6208", withModel: WeatherModel.self) { (result) in
//            switch result {
//            case .success(let payload):
//                if let current = payload?.data.current.first {
//                    print("Today:")
//                    print("\(current.temperature) - \(current.feelsLike)")
//                }
//                if let forecast = payload?.data.forecast {
//                    print("Forecast:")
//                    for day in forecast {
//                        print("\(day.date) - \(day.maxTemperature) - \(day.minTemperature)")
//                    }
//                }
//            case .failure(let error):
//                   print(error)
//            }
//
//        }
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
        viewModel.updateWeatherList()
        self.tableView.reloadData()
    }
    
    func citySearch(_ tableView: CitySearchTableViewController, shouldAdd city: CitySearchViewModel) -> Bool {
        return !viewModel.contains(city)
    }
}
