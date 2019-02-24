
import Foundation
import UIKit

class WeatherListCell: UITableViewCell {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    var viewModel: WeatherListCellViewModel?
}

// MARK: - Public
extension WeatherListCell {
    func setUpCell(with viewModel: WeatherListCellViewModel) {
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        
        self.cityNameLabel.text = viewModel.cityWeather.city.name
        self.temperatureLabel.text = viewModel.temperature
        self.feelsLikeLabel.text = viewModel.feelsLike
        self.shouldShowLoading(viewModel.isUpdating)
    }
    
    func updateWeather() {
        viewModel?.updateWeather()
    }
    
    var isCelUpdating: Bool {
        return viewModel?.isUpdating ?? false
    }
}

// MARK: - Private
extension WeatherListCell {
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
}

// MARK: - View model delegate
extension WeatherListCell: WeatherListCellViewModelDelegate {
    func weatherListCellViewModel(_ viewModel: WeatherListCellViewModel, didUpdate weather: CityWeatherModel?) {
        DispatchQueue.main.async { [weak self] in
            self?.temperatureLabel.text = viewModel.temperature
            self?.feelsLikeLabel.text = viewModel.feelsLike
        }
    }
    
    func weatherListCellViewModel(_ viewModel: WeatherListCellViewModel, didUpdate loadingStatus: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.shouldShowLoading(loadingStatus)
        }
    }
}


