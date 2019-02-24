struct WeatherDetailCellViewModel {
    private var forecast: ForecastWeatherModel
    
    init(with forecast: ForecastWeatherModel) {
        self.forecast = forecast
    }
    
    var day: String {
        return WeatherDate().weekDay(from: forecast.date)
    }
    
    var maxTemperatureDisplayString: String {
        return "\(forecast.maxTemperature)°"
    }
    
    var minTemperatureDisplayString: String {
        return "\(forecast.minTemperature)°"
    }
    
    var maxTitle: String {
        return "Warmste"
    }
    
    var minTitle: String {
        return "Koudste"
    }
}
