import UIKit

enum MainScreenFlowType: Identifiable, CaseIterable, Hashable {
    case catalog
    case tracker
    case health
    
    var id: Self {
        self
    }
    
    var image: ImageResource {
        switch self {
            case .catalog:
                    .Images.Main.catalog
            case .tracker:
                    .Images.Main.tracker
            case .health:
                    .Images.Main.health
        }
    }
}
