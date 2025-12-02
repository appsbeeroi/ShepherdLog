import UIKit

enum HerdType: Identifiable, CaseIterable, Hashable, Codable {
    case sheep
    case goat
    case cow
    case chicken
    
    var title: String {
        switch self {
            case .sheep:
                "Sheep"
            case .goat:
                "Goat"
            case .cow:
                "Cow"
            case .chicken:
                "Chicken"
        }
    }
    
    var icon: ImageResource {
        switch self {
            case .sheep:
                    .Images.Herd.sheep
            case .goat:
                    .Images.Herd.goat
            case .cow:
                    .Images.Herd.cow
            case .chicken:
                    .Images.Herd.chicken
        }
    }
    
    var id: Self {
        self
    }
}
