import Foundation

struct DailyHerd: Identifiable, Codable, Hashable {
    let id: UUID
    var weatherType: WeatherType?
    var exitTime: Date
    var returnTime: Date
    var notes: String
    
    var isReadyToSave: Bool {
        weatherType != nil && notes != ""
    }
    
    init(isReal: Bool) {
        self.id = UUID()
        self.weatherType = isReal ? nil : .cloudy
        self.exitTime = Date()
        self.returnTime = Date()
        self.notes = isReal ? "" : "No notes"
    }
}
