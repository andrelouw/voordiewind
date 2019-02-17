import Foundation

class CitySearchListViewModel {
    private var cities: [CitySearchViewModel]? {
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
    
    // binding closures
    var reloadTableViewClosure: (() -> ())?
    var updateLoadingStatus: ((_ isLoading: Bool) -> ())?
}

// MARK: - Public interface
extension CitySearchListViewModel {
    var numberOfRows: Int {
        if shouldShowErrorMessage {
            return 1
        } else if let numberOfCities = cities?.count {
            return numberOfCities
        }
        return 0
    }
    
    func city(for row: Int) -> CitySearchViewModel? {
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
    
    func cellDescription(for row: Int) -> String? {
        if !shouldShowErrorMessage, let country = cities?[row].country {
            return country
        }
        return nil
    }
    
    func search(for city: String?) {
        if let cityString = city, !cityString.isEmpty {
            isSearching = true
            WeatherService().getCities(for: cityString) { [weak self] (result) in
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
extension CitySearchListViewModel {
    private func updateCities(with model: CitySearchModel) {
        cities = []
        for city in model.search.results {
            cities?.append(CitySearchViewModel(
                name: city.name.first?["value"] ?? "",
                region: "",
                country: "",
                latitude: 0.00,
                longitude: 0.00))
        }
    }
    
    private func resetCities() {
        cities = nil
    }
}

// MARK: - Network call
extension CitySearchListViewModel {
    private func isServiceCallBackStillValid() -> Bool {
        // TODO: Check logic here, maybe delegate?
        return true
        // Check if string is still valid, things might have changed since we last spoke
        //                if self?.searchController.searchBar.text?.isEmpty ?? true {
        //                    self?.errorMessage = nil
        //                    return
        //                }
        //
    }
    
    private func handleSearchSuccess(with payload: WeatherService.CitySearchResultType?) {
        if let knownPayload = payload {
            errorMessage = nil
            updateCities(with: knownPayload)
        } else {
            errorMessage = noDataMessage
            resetCities()
        }
    }
    
    private func handleSearchFailure(with error: WebServiceFailure?) {
        resetCities()
        if let error = error {
            switch error {
            case .parsingFailed(_):
                errorMessage = noDataMessage
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
        // TODO: set empty search flag
    }
}

// MARK: - Messages
extension CitySearchListViewModel {
    private var shouldShowErrorMessage: Bool {
        if errorMessage != nil {
            return true
        }
        return false
    }
    
    private var noDataMessage: String {
        return "Geen stad te vinde"
    }
    
    private var querySearchErrorMessage: String {
        return "Oeps, daar kak hy"
    }
}
