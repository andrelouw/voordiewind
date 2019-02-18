
import Foundation
import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var viewModel: WeatherViewModel?
    
    func setUpCell(with viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        self.cityNameLabel.text = viewModel.name
        setUpBinding()
    }
    
    func setUpBinding() {
        viewModel?.didUpdateCurrentWeather = { [weak self] () in
            DispatchQueue.main.async {
                self?.temperatureLabel.text = self?.viewModel?.temperature
            }
        }
    }
}
