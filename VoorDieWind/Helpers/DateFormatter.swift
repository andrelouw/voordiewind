import Foundation

class WeatherDate {
    
    lazy var weatherDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    lazy var displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    lazy var calendar: Calendar = {
        return Calendar(identifier: .gregorian)
    }()
    
    func date(from string: String) -> Date? {
        return weatherDateFormatter.date(from: string)
    }
    
    func weekDay(from date: Date) -> String {
        if calendar.isDateInToday(date){
            return "Vandag"
        } else if calendar.isDateInTomorrow(date) {
            return "Môre"
        }
        return daysOfTheWeek[calendar.component(.weekday, from: date) - 1]
    }
    
    func displayDate(from date: Date) -> String {
        return displayDateFormatter.string(from: date)
    }
}

extension WeatherDate {
    var daysOfTheWeek: [String] {
        return [ "Sondag", "Maandag", "Dinsdag", "Woensdag", "Donderdag", "Vrydag", "Saturdag"]
    }
}
