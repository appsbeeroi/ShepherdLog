enum WeatherType: String, Hashable, Codable, Identifiable, CaseIterable {
    case sunny = "Sunny"
    case windy = "Windy"
    case rainy = "Rainy"
    case cloudy = "Cloudy"
    
    var icon: ImageResource {
        switch self {
            case .sunny:
                    .Images.Tracker.sunny
            case .windy:
                    .Images.Tracker.windy
            case .rainy:
                    .Images.Tracker.rainy
            case .cloudy:
                    .Images.Tracker.cloudy
        }
    }
    
    var id: Self {
        self
    }
}
