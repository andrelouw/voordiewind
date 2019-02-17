//
//  WeatherListTableViewController.swift
//  VoorDieWind
//
//  Created by Andre Louw on 2019/02/14.
//  Copyright © 2019 Andre Louw. All rights reserved.
//

import Foundation
import UIKit

class WeatherListTableViewController: UITableViewController {
    
    var cities = [CitySearchViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Voor die wind"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell
        else { return UITableViewCell() }
        
        cell.cityNameLabel.text = cities[indexPath.row].name
        cell.temperatureLabel.text = "30°" // shift option 8 to get degrees
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func showAddCity() {
       performSegue(withIdentifier: "showAddCity", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nav = segue.destination as? UINavigationController,
            let vc = nav.viewControllers.first as? AddCityTableViewController else { return }
        
        vc.delegate = self
    }
}

extension WeatherListTableViewController: AddCityTableViewControllerDelegate {
    func addCity(_ tableView: AddCityTableViewController, didSelect city: CitySearchViewModel) {
        cities.append(city)
        self.tableView.reloadData()
    }
}
