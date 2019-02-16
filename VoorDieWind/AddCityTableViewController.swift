//
//  AddCityViewController.swift
//  VoorDieWind
//
//  Created by Andre Louw on 2019/02/14.
//  Copyright © 2019 Andre Louw. All rights reserved.
//

import Foundation
import UIKit

protocol AddCityTableViewControllerDelegate {
    func addCity(_ tableView: AddCityTableViewController, didSelect city: CitySearchViewModel)
}

class AddCityTableViewController : UITableViewController {
    
    let searchController = CustomSearchController(searchResultsController: nil) // nil -> use this view
    var delegate: AddCityTableViewControllerDelegate?
    var cities: CitySearchListViewModel?
    var shouldShowLoadingText: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        navigationItem.prompt = "Soek jou stad"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Kanseleer", style: .plain, target: self, action: #selector(dismissViewController))
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
    
        // searchbar
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Sleutel 'n stad naam in"
        navigationItem.titleView = searchController.searchBar
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delay(0.1) {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    @objc func dismissViewController() {
        searchController.isActive = false
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.citySearchViewModels.count ?? (shouldShowLoadingText ? 1 : 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") else { return UITableViewCell() }
        
        if let city = cities?.citySearchViewModels[indexPath.row] {
            cell.textLabel?.text = city.cityName
        } else {
            cell.textLabel?.text = "Aanhouer wen..."
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let city = cities?.citySearchViewModels[indexPath.row] else { return }
        delegate?.addCity(self, didSelect: city)
        self.dismissViewController()
    }
}


extension AddCityTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
 
        if let city = searchController.searchBar.text,
            !city.isEmpty {
            searchController.searchBar.isLoading = true
            shouldShowLoadingText = true
            // TODO: Break this out to a service
            let weatherURL = URL(string: "http://api.worldweatheronline.com/premium/v1/search.ashx?query=\(city)&key=ed4a649fd5bd49b5a9425943190702&format=json")!
            let weatherResource = Resource<CitySearchListViewModel>(url: weatherURL) { data in
                
                if let searchModel = try? JSONDecoder().decode(CitySearchModel.self, from: data) {
                    // This needs to be reworked
                    self.cities = CitySearchListViewModel(from: searchModel)
                    print(self.cities)
                    self.tableView.reloadData()
                    return self.cities
                } else {
                    self.cities = nil
                    self.tableView.reloadData()
                    return nil
                }
            }
            
            WebService().load(resource: weatherResource) { result in
                searchController.searchBar.isLoading = false
            }
        } else {
            shouldShowLoadingText = false
            self.tableView.reloadData()
        }
    }
}


// Needed beacuase of some bug where cancel button wont dissapear
class CustomSearchController: UISearchController {
    let customSearchBar = CustomSearchBar()
    override var searchBar: UISearchBar {
        return customSearchBar
    }
}

class CustomSearchBar: UISearchBar {
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        //
    }
}

extension UISearchBar {
    private var textField: UITextField? {
        let subViews = self.subviews.flatMap { $0.subviews }
        return (subViews.filter { $0 is UITextField }).first as? UITextField
    }
    
    private var searchIcon: UIImage? {
        return UITabBarItem(tabBarSystemItem: .search, tag: 0).image
    }

    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let _activityIndicator = UIActivityIndicatorView(style: .gray)
                    _activityIndicator.startAnimating()
                    _activityIndicator.backgroundColor = UIColor.clear
                    self.setImage(UIImage(), for: .search, state: .normal)
                    textField?.leftView?.addSubview(_activityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    _activityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                self.setImage(searchIcon, for: .search, state: .normal)
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}
