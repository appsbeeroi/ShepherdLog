import Foundation

struct HealthNote: Identifiable, Hashable, Codable {
    let id: UUID
    var date: Date
    var type: HerdType?
    var status: String
    
    var isReadyToSave: Bool {
        type != nil && status != ""
    }
    
    init(isReal: Bool) {
        self.id = UUID()
        self.date = Date()
        self.type = isReal ? nil : .chicken
        self.status = isReal ? "" : "Vaccinated"
    }
}
