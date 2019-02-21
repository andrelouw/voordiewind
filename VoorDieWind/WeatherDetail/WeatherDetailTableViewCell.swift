//
//  WeatherDetailTableViewCell.swift
//  VoorDieWind
//
//  Created by Andre Louw on 2019/02/21.
//  Copyright © 2019 Andre Louw. All rights reserved.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxTemperatrueLabel: UILabel!
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
        dateLabel.text = "30 Jan 2019"
        maxTemperatrueLabel.text = "30°"
        minTemperatureLabel.text = "30°"
        // Initialization code
    }
    
    func shouldShowHeadings(_ show: Bool) {
        headingStackView.isHidden = !show
    }
}
