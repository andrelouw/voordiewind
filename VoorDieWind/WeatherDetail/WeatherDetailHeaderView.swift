import UIKit

class WeatherDetailHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        applyStyling()
    }
    
    func applyStyling() {
        currentTemperatureLabel.font = UIFont.systemFont(ofSize: 80.0)
        currentDateLabel.font = UIFont.systemFont(ofSize: 20.0)
    }
}
