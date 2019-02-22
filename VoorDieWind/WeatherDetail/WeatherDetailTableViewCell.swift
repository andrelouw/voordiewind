import UIKit

struct WeatherDetailTableViewCellViewModel {
    var date: String
    var maxTemperature: String
    var minTemperature: String
    
    var maxTemperatureDisplayString: String {
        return "\(maxTemperature)°"
    }
    
    var minTemperatureDisplayString: String {
        return "\(minTemperature)°"
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
    
    func setUpCell(with viewModel: WeatherDetailTableViewCellViewModel) {
        dateLabel.text = viewModel.date
        maxTemperatureLabel.text = viewModel.maxTemperatureDisplayString
        minTemperatureLabel.text = viewModel.minTemperatureDisplayString
    }
    
    func shouldShowHeadings(_ show: Bool) {
        headingStackView.isHidden = !show
    }
}
