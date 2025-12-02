import Foundation

struct Herd: Identifiable, Codable, Hashable {
    let id: UUID
    var type: HerdType?
    var number: String
    
    var isReadyToSave: Bool {
        type != nil && !number.isEmpty
    }
    
    init(isReal: Bool) {
        self.id = UUID()
        self.type = isReal ? nil : .sheep
        self.number = isReal ? "" : "3"
    }
}
