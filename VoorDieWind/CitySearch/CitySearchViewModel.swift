import Foundation
import UIKit

class CitySearchViewModel {
    typealias CitySearchResultType = CitySearchModel
    
    private var cities: [CityModel]? {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    private var isSearching: Bool = false {
        didSet {
            self.updateLoadingStatus?(isSearching)
        }
    }
    
    private var errorMessage: String?
    
    // binding closures -> example of closures
    var reloadTableViewClosure: (() -> ())?
    var updateLoadingStatus: ((_ isLoading: Bool) -> ())?
}

// MARK: - Public interface
extension CitySearchViewModel {
    var numberOfRows: Int {
        if shouldShowErrorMessage {
            return 1
        } else if let numberOfCities = cities?.count {
            return numberOfCities
        }
        return 0
    }
    
    func isUserInteractionEnabled(for indexPath: IndexPath) -> Bool {
        if shouldShowErrorMessage {
            return false
        } else if let _ = cities?[indexPath.row] {
            return true
        }
        return false
    }
    
    func city(for row: Int) -> CityModel? {
        if !shouldShowErrorMessage, let city = cities?[row] {
            return city
        }
        return nil
    }
    
    func cellTitle(for row: Int) -> String? {
        if shouldShowErrorMessage {
            return errorMessage
        } else if let name = cities?[row].name {
            return name
        }
        return nil
    }
    
    func cellSubtitle(for row: Int) -> String? {
        if shouldShowErrorMessage {
            if errorMessage == noDataCellMessage {
                return noDataMessageSubtitle
            } else if errorMessage == querySearchErrorMessage {
                return querySearchErrorMessageSubtitle
            }
        } else if let subtitle = subtitle(for: cities?[row]) {
            return subtitle
        }
        return nil
    }
    
    func search(for city: String?) {
        if let cityString = city, !cityString.isEmpty {
            isSearching = true
            
            WeatherService().get(.search, for: cityString, withModel: CitySearchResultType.self) { [weak self] (result) in
                self?.isSearching = false
                switch result {
                case .success(let payload):
                    self?.handleSearchSuccess(with: payload)
                case .failure(let error):
                    self?.handleSearchFailure(with: error)
                }
            }
        } else {
            handleEmptySearch()
        }
    }
}

// MARK: - Cities
extension CitySearchViewModel {
    private func addCities(from searchModel: CitySearchModel) {
        cities = []
        for city in searchModel.search.results {
                cities?.append(city)
        }
    }
    
    private func resetCities() {
        cities = nil
    }
}

// MARK: - Network handler
extension CitySearchViewModel {
    private func isServiceCallBackStillValid() -> Bool {
        // TODO: Check logic here, maybe delegate?
        // Check if string is still valid, things might have changed since we last spoke
        // APi should actually send you back the search string
        return true
    }
    
    private func handleSearchSuccess(with payload: CitySearchResultType?) {
        if let knownPayload = payload {
            errorMessage = nil
            addCities(from: knownPayload)
        } else {
            errorMessage = noDataCellMessage
            resetCities()
        }
    }
    
    private func handleSearchFailure(with error: WebServiceFailure?) {
        resetCities()
        if let error = error {
            switch error {
            case .parsingFailed(_):
                errorMessage = noDataCellMessage
                print("Unable to find any matching weather location to the query submitted!")
            default:
                errorMessage = querySearchErrorMessage
                print(error.message)
            }
        } else {
            errorMessage = querySearchErrorMessage
            print("No error returned")
        }
    }
    
    private func handleEmptySearch() {
        errorMessage = nil
        resetCities()
    }
}

// MARK: - Messages
extension CitySearchViewModel {
    private var shouldShowErrorMessage: Bool {
        if errorMessage != nil {
            return true
        }
        return false
    }
    
  
}

// MARK: - Strings
extension CitySearchViewModel {
    private func subtitle(for city: CityModel?) -> String? {
        if let region = city?.region, let country = city?.country {
            if !region.isEmpty && !country.isEmpty {
                return "\(region) • \(country)"
            }
            
            if !region.isEmpty {
                return "\(region)"
            }
            
            if !country.isEmpty {
                return "\(country)"
            }
        }
        return nil
    }
    
    private var noDataCellMessage: String {
        return "Geen stad te vinde"
    }
    
    private var querySearchErrorMessage: String {
        return "Oeps, daar kak hy!"
    }
    
    private var noDataMessageSubtitle: String {
        return "Daardie help ons nie, bietjie meer inligting asb!"
    }
    
    private var querySearchErrorMessageSubtitle: String {
        return "Sulke dinge gebeur maar..."
    }
    
    var navigationPrompt: String {
        return "Soek jou stad"
    }
    
    var cancelButton: String {
        return "Kanselleer"
    }
    
    var searchPlaceHolder: String {
        return "Sleutel 'n stad naam in"
    }
    
    var noDataTitle: String {
        return "Vind jou stad"
    }
    
    var noDataMessage: String {
        return "Soek jou stad in die soek paneel"
    }
    
    var noDataImage: UIImage {
        return UIImage(named: "city") ?? UIImage()
    }
    
    var addAlertTitle: String {
        return "Kies 'n ander een"
    }
    
    var addAlertMessage: String {
        return "Die stad is reeds in jou voer, of het jy vergeet?"
    }
    
    var addAlertCancel: String {
        return "Goed so!"
    }
}
