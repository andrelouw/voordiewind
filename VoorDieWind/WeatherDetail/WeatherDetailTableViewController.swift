import Foundation
import UIKit

class WeatherDetailTableViewController: UITableViewController {
    var viewModel: WeatherDetailViewModel?

    init(with viewModel: WeatherDetailViewModel) {
        super.init(style: .plain)
        self.viewModel = viewModel
        
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
        title = viewModel?.title
        tableView.isUserInteractionEnabled = false
    }
}

extension WeatherDetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
}

// MARK: - Cells
extension WeatherDetailTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailTableViewCell", for: indexPath) as? WeatherDetailTableViewCell,
            let model = viewModel?.forecast(for: indexPath) else { return UITableViewCell() }
        
        let cellViewModel = WeatherDetailTableViewCellViewModel(with: model)
        cell.setUpCell(with: cellViewModel)

        if indexPath.row > 0 {
            cell.shouldShowHeadings(false)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WeatherDetailHeaderView") as? WeatherDetailHeaderView else {
            return UITableViewHeaderFooterView() }
        
        headerView.currentTemperatureLabel.text = viewModel?.currentTemperature
        headerView.currentDateLabel.text = viewModel?.currentDate
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}


