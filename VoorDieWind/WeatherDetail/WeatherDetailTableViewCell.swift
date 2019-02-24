import UIKit

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
    }
    
    func setUpCell(with viewModel: WeatherDetailCellViewModel) {
        dateLabel.text = viewModel.day
        maxTemperatureLabel.text = viewModel.maxTemperatureDisplayString
        minTemperatureLabel.text = viewModel.minTemperatureDisplayString
        maxHeadingLabel.text = viewModel.maxTitle
        minHeadingLabel.text = viewModel.minTitle
    }
    
    func shouldShowHeadings(_ show: Bool) {
        headingStackView.isHidden = !show
    }
}
