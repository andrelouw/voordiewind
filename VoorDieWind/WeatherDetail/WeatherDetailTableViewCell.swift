import UIKit

// TODO: Move to own file
struct WeatherDetailCellViewModel {
    private var forecast: ForecastWeatherModel
    
    init(with forecast: ForecastWeatherModel) {
        self.forecast = forecast
    }
    
    var day: String {
        return WeatherDate().weekDay(from: forecast.date)
    }

    var maxTemperatureDisplayString: String {
        return "\(forecast.maxTemperature)°"
    }

    var minTemperatureDisplayString: String {
        return "\(forecast.minTemperature)°"
    }
}

class WeatherDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var headingStackView: UIStackView!
    @IBOutlet weak var maxHeadingLabel: UILabel!
    @IBOutlet weak var minHeadingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        maxHeadingLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        minHeadingLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        maxHeadingLabel.text = "Max"
        minHeadingLabel.text = "Min"
    }
    
    func setUpCell(with viewModel: WeatherDetailCellViewModel) {
        dateLabel.text = viewModel.day
        maxTemperatureLabel.text = viewModel.maxTemperatureDisplayString
        minTemperatureLabel.text = viewModel.minTemperatureDisplayString
    }
    
    func shouldShowHeadings(_ show: Bool) {
        headingStackView.isHidden = !show
    }
}
