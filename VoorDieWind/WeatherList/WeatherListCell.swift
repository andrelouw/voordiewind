
import Foundation
import UIKit

class WeatherListCell: UITableViewCell {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    var viewModel: WeatherListCellViewModel?
    
    func setUpCell(with viewModel: WeatherListCellViewModel) {
        self.viewModel = viewModel
        
        
        
        self.cityNameLabel.text = viewModel.cityWeather.city.name
        self.temperatureLabel.text = viewModel.temperature
        self.feelsLikeLabel.text = viewModel.feelsLike
        self.shouldShowLoading(viewModel.isUpdating)
        setUpBinding()
    }
    
    private func shouldShowLoading(_ isLoading: Bool) {
        if isLoading {
            self.loadingActivityIndicator.startAnimating()
            self.temperatureLabel.isHidden = true
            self.feelsLikeLabel.isHidden = true
        } else {
            self.loadingActivityIndicator.stopAnimating()
            self.temperatureLabel.isHidden = false
            self.feelsLikeLabel.isHidden = false
        }
    }
    
    private func setUpBinding() {
        viewModel?.didUpdateCurrentWeather = { [weak self] () in
            DispatchQueue.main.async {
                self?.temperatureLabel.text = self?.viewModel?.temperature
                self?.feelsLikeLabel.text = self?.viewModel?.feelsLike
            }
        }
        
        viewModel?.updateWeatherLoadingStatus = { [weak self] (isUpdating) in
            DispatchQueue.main.async {
                self?.shouldShowLoading(isUpdating)
            }
        }
    }
    
    func updateWeather() {
        viewModel?.updateWeather()
    }
    
    var isCelUpdating: Bool {
        return viewModel?.isUpdating ?? false
    }
}


