import Foundation
import UIKit

class WeatherDetailTableViewController: UITableViewController {
    var viewModel: WeatherDetailViewModel?

    init(with model: WeatherViewModel) {
        super.init(style: .plain)
        viewModel = WeatherDetailViewModel(with: model)
        
        let headerNib = UINib.init(nibName: "WeatherDetailHeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "WeatherDetailHeaderView")
        let cellNib = UINib.init(nibName: "WeatherDetailTableViewCell", bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: "WeatherDetailTableViewCell")
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        title = viewModel?.name
        tableView.isUserInteractionEnabled = false
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WeatherDetailHeaderView") as? WeatherDetailHeaderView else {
            return UITableViewHeaderFooterView() }
        
        
        headerView.currentTemperatureLabel.text = "30°"
        headerView.currentDateLabel.text = "30 Jan 2019"
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailTableViewCell", for: indexPath) as? WeatherDetailTableViewCell else {
                return UITableViewCell()
            }
        
        if indexPath.row > 0 {
            cell.shouldShowHeadings(false)
        } else {
            cell.dateLabel.text = "Today"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


